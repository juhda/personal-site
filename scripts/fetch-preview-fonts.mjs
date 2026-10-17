// Fetches the preview fonts for tinymist's paged preview into preview-fonts/.
// The directory is gitignored: the font binaries are ~25MB and only the
// editor preview needs them (the served site renders emoji client-side in
// the visitor's browser). Runs automatically on codespace creation via the
// postCreateCommand in .devcontainer/devcontainer.json, or manually:
//
//   npm run fetch:preview-fonts
//
// The codespace's system fonts include no emoji font, so without Noto Color
// Emoji the paged preview renders emoji as missing glyphs (see README,
// Development Notes).

import { mkdir, rename, stat, unlink } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const FONTS = [
  {
    name: "NotoColorEmoji-Regular.ttf",
    // COLRv1 vector build: sharp at any preview zoom; the font browsers on
    // Linux/Android resolve for emoji, and the closest redistributable
    // match to what readers see on other platforms. The site's text fonts
    // (Inter/Lato) are not fetched: they are not set in the posts (the
    // preview uses Typst's default) and the served pages load them from
    // Google Fonts (see src/layouts).
    url: "https://github.com/google/fonts/raw/main/ofl/notocoloremoji/NotoColorEmoji-Regular.ttf",
    minBytes: 10 * 1024 * 1024,
  },
];

const force = process.argv.includes("--force");
const dir = resolve(dirname(fileURLToPath(import.meta.url)), "..", "preview-fonts");
await mkdir(dir, { recursive: true });

for (const font of FONTS) {
  const dest = resolve(dir, font.name);
  const present = await stat(dest).then((s) => s.size >= font.minBytes).catch(() => false);
  if (present && !force) {
    console.log(`preview-fonts: ${font.name} already present, skipping (use --force to refetch)`);
    continue;
  }

  console.log(`preview-fonts: fetching ${font.name} ...`);
  const res = await fetch(font.url, { redirect: "follow" });
  if (!res.ok) {
    throw new Error(`fetching ${font.name} failed: ${res.status} ${res.statusText}`);
  }
  // Download to a temp file and rename only once complete, so an
  // interrupted fetch never leaves a truncated font behind.
  const tmp = dest + ".part";
  await unlink(tmp).catch(() => {});
  await writeFileFromResponse(res, tmp);
  const size = (await stat(tmp)).size;
  if (size < font.minBytes) {
    await unlink(tmp);
    throw new Error(`fetched ${font.name} is suspiciously small (${size} bytes)`);
  }
  await rename(tmp, dest);
  console.log(`preview-fonts: ${font.name} (${size} bytes) saved`);
}

async function writeFileFromResponse(res, path) {
  const { createWriteStream } = await import("node:fs");
  const { Readable } = await import("node:stream");
  const { pipeline } = await import("node:stream/promises");
  await pipeline(Readable.fromWeb(res.body), createWriteStream(path));
}
