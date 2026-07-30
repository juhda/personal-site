import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const OUTPUT_DIR = path.resolve(__dirname, '../public');

async function main() {
  const key = process.env.INDEXNOW_KEY;

  if (!key) {
    console.warn(
      "[indexnow] WARN: INDEXNOW_KEY is not defined. Skipping IndexNow key file generation.",
    );
    process.exit(0);
  }

  const output_path = path.resolve(OUTPUT_DIR, `${key}.txt`);

  await fs.mkdir(path.dirname(output_path), { recursive: true });
  await fs.writeFile(output_path, key, 'utf-8');

  console.log(`[indexnow] Generated IndexNow verification file: ${key}.txt`);
}

main().catch(err => {
  console.error('[indexnow] Failed to generate IndexNow key file:', err);
  process.exit(1);
});
