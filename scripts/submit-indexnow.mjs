// Post-build IndexNow submission.
//
// Compares the freshly built sitemap against the currently deployed (live)
// sitemap and submits the symmetric difference (added and removed URLs) to
// IndexNow. The live sitemap is the previous deploy's URL set — the correct
// baseline. Requires Node >= 22 (native Set.symmetricDifference).
//
// Gracefully skips: missing INDEXNOW_KEY, missing/invalid baseline (first
// deploy: submits nothing), no changes, or network failure.
//
// Failure semantics (best effort — no persistent state):
//   - Transient failures (network, 5xx) are retried up to SUBMIT_ATTEMPTS
//     times with backoff.
//   - A submission that still fails is LOST for the diff: the deploy goes
//     out, the live sitemap advances, and the next deploy's baseline already
//     contains the failed URLs. The pages remain live and crawlable via
//     sitemap.xml — only the accelerated IndexNow notification is missed.
//     Manual recovery at any time: `npm run build && npm run
//     submit:indexnow -- --all` resubmits the entire sitemap.
//
// Run after `astro build` (wired into npm run build).

import { readFile } from "node:fs/promises";

const INDEXNOW_ENDPOINT = "https://api.indexnow.org/indexnow";
const SUBMIT_ATTEMPTS = 3;
const RETRY_DELAYS_MS = [5_000, 15_000];

const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

async function main() {
  const forceAll = process.argv.includes("--all");

  const key = process.env.INDEXNOW_KEY;
  if (!key) {
    console.log("[indexnow] INDEXNOW_KEY not defined. Skipping submission.");
    return;
  }

  const site = process.env.URL;
  if (!site) {
    console.warn("[indexnow] URL not defined. Skipping submission.");
    return;
  }

  const siteUrl = new URL(site);

  // Freshly built sitemap.
  let newXml;
  try {
    newXml = await readFile("dist/sitemap.xml", "utf8");
  } catch (err) {
    console.warn(`[indexnow] Could not read dist/sitemap.xml: ${err.message}. Skipping.`);
    return;
  }
  const newSet = new Set(extractUrls(newXml));
  if (newSet.size === 0) {
    console.warn("[indexnow] Fresh sitemap contains no URLs. Skipping.");
    return;
  }

  // --all: manual recovery — submit every URL in the built sitemap.
  if (forceAll) {
    console.log(`[indexnow] --all: submitting all ${newSet.size} URL(s).`);
    await submitUrls([...newSet], siteUrl, key);
    return;
  }

  // Baseline: currently deployed sitemap (cache-busted).
  let baselineUrls;
  try {
    const res = await fetch(new URL(`/sitemap.xml?cb=${Date.now()}`, siteUrl), {
      headers: { "Cache-Control": "no-cache" },
    });
    if (res.ok) {
      baselineUrls = new Set(extractUrls(await res.text()));
    } else {
      console.warn(`[indexnow] Baseline fetch returned ${res.status}. Treating as first deploy (nothing to diff against; skipping to avoid resubmitting everything).`);
    }
  } catch (err) {
    console.warn(`[indexnow] Baseline fetch failed: ${err.message}. Skipping.`);
    return;
  }

  // URLs added or removed since the previous deploy. Removed URLs are
  // included deliberately — crawlers re-fetch, see the removal, and de-index.
  const changed = baselineUrls ? baselineUrls.symmetricDifference(newSet) : new Set();
  const urlsToSubmit = [...changed];

  if (urlsToSubmit.length === 0) {
    console.log("[indexnow] No changed URLs to submit.");
    return;
  }

  await submitUrls(urlsToSubmit, siteUrl, key);
}

/** Submit urlList to IndexNow, retrying transient failures with backoff.
 *  4xx responses are not retried (deterministic — usually a bad key). */
async function submitUrls(urlsToSubmit, siteUrl, key) {
  for (let attempt = 1; attempt <= SUBMIT_ATTEMPTS; attempt++) {
    let res;
    try {
      res = await fetch(INDEXNOW_ENDPOINT, {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=utf-8" },
        body: JSON.stringify({
          host: siteUrl.host,
          key,
          urlList: urlsToSubmit,
        }),
      });
    } catch (err) {
      if (attempt < SUBMIT_ATTEMPTS) {
        console.warn(`[indexnow] Submission attempt ${attempt}/${SUBMIT_ATTEMPTS} failed (${err.message}). Retrying in ${RETRY_DELAYS_MS[attempt - 1] / 1000}s...`);
        await sleep(RETRY_DELAYS_MS[attempt - 1]);
        continue;
      }
      console.warn(`[indexnow] Submission failed after ${SUBMIT_ATTEMPTS} attempts (${err.message}).`);
      console.warn("[indexnow] The deploy publishes normally; the pages stay live and crawlable via sitemap.xml, but the IndexNow notification for them is lost. Manual recovery: npm run build && npm run submit:indexnow -- --all");
      return;
    }
    if (res.ok) {
      console.log(`[indexnow] Submitted ${urlsToSubmit.length} changed URL(s).`);
      return;
    }
    if (res.status < 500) {
      // Deterministic failure — retrying will not help.
      console.warn(`[indexnow] Submission rejected: ${res.status} ${res.statusText}. Check the INDEXNOW_KEY. Not retrying.`);
      console.warn("[indexnow] The deploy publishes normally; the pages stay live and crawlable via sitemap.xml. Manual recovery: npm run build && npm run submit:indexnow -- --all");
      return;
    }
    if (attempt < SUBMIT_ATTEMPTS) {
      console.warn(`[indexnow] Submission attempt ${attempt}/${SUBMIT_ATTEMPTS} got ${res.status} ${res.statusText}. Retrying in ${RETRY_DELAYS_MS[attempt - 1] / 1000}s...`);
      await sleep(RETRY_DELAYS_MS[attempt - 1]);
      continue;
    }
    console.warn(`[indexnow] Submission failed after ${SUBMIT_ATTEMPTS} attempts (${res.status} ${res.statusText}).`);
    console.warn("[indexnow] The deploy publishes normally; the pages stay live and crawlable via sitemap.xml, but the IndexNow notification for them is lost. Manual recovery: npm run build && npm run submit:indexnow -- --all");
  }
}

function extractUrls(xml) {
  const urls = new Set();
  for (const m of xml.matchAll(/<loc>([^<]+)<\/loc>/g)) {
    urls.add(m[1]);
  }
  return [...urls];
}

main().catch(err => {
  console.warn(`[indexnow] Unexpected failure (skipping): ${err.message}`);
});
