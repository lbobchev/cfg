# Global Claude Code instructions

## Azure DevOps: `#id` (work item) vs `!id` (pull request)

In Azure DevOps, numeric references are disambiguated by prefix:
- `#<id>` links to a **work item**
- `!<id>` links to a **pull request**

Work items and PRs share one number space, so `#82288` (meaning a PR) silently resolves to **work item** 82288 — often an unrelated bug.

**Rule:** When referencing a PR anywhere ADO renders markdown — PR descriptions, commit messages, work-item/PR comments — use `!<id>` or the full PR URL, **never** `#<id>`. Reserve `#<id>` strictly for work items. Before writing any `#<number>`, confirm the number is a work item and not a PR. Also avoid stray `#1`/`#2` in prose (e.g. "header #1") since they linkify to work items 1/2.

**Note:** a completed/merged PR's description cannot be edited afterward (TF401181), so get PR references right before merging.

## Write in Simplified Technical English (ASD-STE100)

ASD-STE100 Simplified Technical English (STE) is a controlled-language standard from ASD (the AeroSpace and Defence Industries Association of Europe). It started in 1986 as AECMA Simplified English; the current release is Issue 9 (January 2025). It has **53 writing rules in 9 sections** (word choice, grammar, sentence structure, style) plus a **dictionary of ~900 approved words** (one meaning and one part of speech each) and ~1200 not-approved words with approved alternatives. Its goal: technical text that readers who are not native English speakers understand correctly on the first read. It permits **technical names** and **technical verbs** from a company, project, or industry standard even when they are not in the dictionary.

**Rule:** Write all prose in STE style — chat answers, commit messages, PR titles and descriptions, work-item and PR comments, README and wiki pages, code comments, and log or error messages that a person reads.

**Do not apply STE to:** code, identifiers, file paths, commands, configuration keys, API and product names, versions, quoted text, and command or test output. Copy these exactly. STE simplifies the language **around** a hard term, never the term itself.

Apply these rules:

1. **One idea per sentence.** Maximum 20 words for an instruction or procedure step, 25 words for descriptive text. Maximum 6 sentences per paragraph.
2. **Active voice, imperative for instructions.** Write "Restart the service", not "The service should be restarted".
3. **Simple tenses only.** Use the present, the simple past, and the simple future. Do not use the present perfect ("we have moved the check" → "we moved the check"). Avoid `-ing` forms where a finite verb or a noun is clearer.
4. **One word, one meaning.** Do not change words for variety. Choose one term and repeat it: keep "make sure" everywhere instead of mixing verify / check / confirm / ensure.
5. **Maximum 3 words in a noun cluster.** Break up "database connection pool exhaustion warning" into "the warning that shows an empty pool of database connections".
6. **Put the condition first.** Write "If the build fails, revert the commit."
7. **Keep the articles** (a / an / the). Do not write in telegraphic style.
8. **No slang, idioms, or needless Latin.** Write "for example", "that is", "and so on" instead of e.g., i.e., etc.
9. **Steps as a numbered list**, and put a warning or a caution **before** the step it applies to.

**Hard terms and abbreviations:** on the first use, give the plain-language explanation and put the exact term or the abbreviation in parentheses. Then reuse the short form.

- "a lock that two operations wait on forever (a deadlock)"
- "Simplified Technical English (STE)"
- "the file that lists the packages the project needs (`package.json`)"

Reverse the order when the exact term must lead, for example in a title or an error message: "Deadlock (two operations wait for each other's lock)". Never use an abbreviation that you did not expand one time. Never drop precision — keep exact numbers, versions, and identifiers.

## Code comments: never narrate the change

A comment that narrates a change, cites a work item or an acceptance criterion as rationale, or argues correctness talks to the reviewer, not to the next reader. It becomes noise the moment the change merges.

**Rule:** Do not add inline comments that describe or justify the change, unless the user asks for them. Put the rationale in the commit message and the PR description instead.

- Default to no comment. Match the comment density and idiom of the surrounding code.
- A comment may only state a constraint the code cannot show (for example: a deliberate 404 instead of 403 so existence does not leak). Keep it to one short line.
- Never write: work-item or AC citations as rationale, "moved from X", "was removed", "pre-change behaviour", "byte-for-byte", "unchanged", "instead of", multi-sentence `<remarks>` essays, or fixture notes that explain why a guard rejects the seed.
- Where analyzers require XML doc headers, keep them to one factual line. Trim, do not delete, when the build treats missing docs as errors.
- Pass this rule verbatim to every implementation subagent — agent specs are the main source of these comments.

## Design patterns and architectural consistency

**Rule:** When you suggest a code implementation, treat design patterns, architectural consistency, and domain-driven design (DDD, where appropriate) as key considerations — not afterthoughts.

- Before you propose a design, look at how the codebase already solves the same kind of problem. Consistency with the existing architecture beats a textbook pattern that fights it.
- Name the pattern you apply (for example: Specification, Strategy, value object, anti-corruption layer) and say why it fits — or why the informal shape is enough.
- Apply DDD selectively: a value object or a domain service is often the right small step; full aggregates, repositories, or event sourcing need the codebase and the workload to justify them. Say which DDD steps fit and which do not.
- When an implementation duplicates a rule or scatters a concern, propose the consolidation (one throw-site, one predicate, one context object) in the same suggestion.
- Flag pattern opportunities that are out of scope for the current change as follow-ups, with the reason they cannot land now.

## Model delegation: Fable 5 plans, simpler models write

Fable 5 is the expensive tier. Once the decisions are made, writing code to a precise spec, or authoring HTML/MD markup, is mechanical.

**Rule:** Use Fable 5 for analysis, research, and planning of implementation and code changes. Produce an output that a simpler model can just write up. Use simpler models (Opus 4.6, Sonnet) to write the instructed code, and to write HTML/MD files for artifacts or documentation.

- The spec must let the subagent execute without decisions of its own: exact files and paths, signatures, names, byte-identical strings where they matter, a do-not-touch list, the comment rule above, and the exact verification commands with expected counts.
- Spawn the writer with the `Agent` tool and `model: "sonnet"` (or Opus 4.6).
- Keep verification, diff review, commit/push, and PR or artifact publishing in the Fable 5 session.
