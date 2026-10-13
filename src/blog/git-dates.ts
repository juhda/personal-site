// Git-derived publication dates for blog posts.
//
// publishedAt: author date of the first commit that added the post directory.
// updatedAt:   author date of the last commit that touched the post directory.
//
// Used by the blog content loader for posts whose meta.yaml does not carry
// explicit dates (explicit values always win). Requires a git clone with
// history at build time (Netlify provides one); returns undefined otherwise.

import { execFileSync } from "node:child_process";

function git(args: string[], cwd?: string): string | undefined {
  try {
    return execFileSync("git", args, { encoding: "utf8", cwd }).trim();
  } catch {
    return undefined;
  }
}

/** Date the post directory was first committed, or undefined. */
export function firstCommitDate(postDir: string): string | undefined {
  const out = git([
    "log", "--diff-filter=A", "--reverse", "--format=%aI", "--", postDir,
  ]);
  const first = out?.split("\n")[0];
  return first || undefined;
}

/** Date the post directory was last touched by a commit, or undefined. */
export function lastCommitDate(postDir: string): string | undefined {
  const out = git(["log", "-1", "--format=%aI", "--", postDir]);
  return out || undefined;
}
