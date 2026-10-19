// Compiles the Typst resume source (src/resume/resume.typ) to the PDF served
// at /resume. The output filename is referenced by the /resume redirect in
// astro.config.mjs — keep the two in sync.
//
//   node scripts/generate-resume.mjs
//
// The "last updated" note printed in the resume footer is derived from the git
// history of src/resume (author date of the last commit touching it), so the
// PDF stays honest about its own freshness. Requires a git clone with history
// (Netlify provides one); the note is simply omitted without it.

import { execFileSync } from "node:child_process";
import { mkdir, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { NodeCompiler } from "@myriaddreamin/typst-ts-node-compiler";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const mainFilePath = resolve(root, "src/resume/resume.typ");
const fontsDir = resolve(root, "src/resume/fonts");
const outFile = resolve(root, "public/resume/DavidJuhasz_Resume.pdf");

// Author date of the last commit touching src/resume, as with the blog's
// git-derived dates (src/blog/git-dates.ts).
function lastUpdated() {
  try {
    const iso = execFileSync(
      "git",
      ["log", "-1", "--format=%aI", "--", "src/resume"],
      { encoding: "utf8", cwd: root },
    ).trim();
    if (!iso) return undefined;
    return new Date(iso).toLocaleDateString("en-US", {
      month: "long",
      year: "numeric",
    });
  } catch {
    return undefined;
  }
}

const inputs = {};
const updated = lastUpdated();
if (updated) inputs["last-updated"] = updated;

const compiler = NodeCompiler.create({
  workspace: root,
  fontArgs: [{ fontPaths: [fontsDir] }],
  inputs,
});

const result = compiler.compile({ mainFilePath });
if (result.hasError()) {
  result.printDiagnostics();
  process.exit(1);
}

const pages = result.result?.numOfPages;
if (pages !== 1) {
  console.error(`resume: expected a one-page document, got ${pages}`);
  process.exit(1);
}

const pdf = compiler.pdf(result.result);
await mkdir(dirname(outFile), { recursive: true });
await writeFile(outFile, pdf);
console.log(`resume: wrote public/resume/${outFile.split("/").pop()} (${pdf.length} bytes)` + (updated ? `, last updated ${updated}` : ""));
