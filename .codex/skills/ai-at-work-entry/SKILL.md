---
name: ai-at-work-entry
description: Add or update entries in the AI at Work section of this blog. Use when the user wants to curate an external tweet/X post, blog post, interview, talk, podcast, or similar source into `_ai_at_work/`, either from a URL or from manually provided metadata.
---

# AI at Work Entry

Create content for the repo's `AI at Work` collection in `_ai_at_work/`.

## Use this skill when

- The user wants to add an `AI at Work` item from a URL.
- The user wants to add an `AI at Work` item from notes or partial metadata.
- The user wants to turn an approved GitHub issue submission into an `_ai_at_work/` entry.
- The user wants to refresh metadata, tags, or the TL;DR/commentary for an existing `_ai_at_work/` entry.

## Output target

- Collection directory: `_ai_at_work/`
- One file per entry, named from the final slug: `_ai_at_work/<slug>.md`
- Prefer the repo scaffold helper if it exists:
  `just new-ai-at-work-entry "Title"`
- If the helper does not exist, create the file directly with the same front matter shape.

## Required front matter

Always set:

- `title`
- `slug`
- `publishedAt`
- `type`
- `sourceUrl`
- `author`
- `externalPublishedAt` if available, otherwise leave it blank
- `commentary`
- `tags`

Support these when useful:

- `sourceName`
- `authorUrl`
- `summary`
- `quote`
- `image`
- `draft`

The collection has a default layout in `_config.yml`, so you usually do not need
to set `layout` explicitly.

## Workflow

### If the user provides a URL

1. Read the source on the web.
2. Extract the title, source name, author, source type, original publish date, and a short summary if it is clearly available.
3. Choose 2-5 focused tags. Prefer tags already used by the section, such as `ai-adoption`, `engineering`, `agents`, `workflows`, `leadership`, `org-design`, `ai-coding`, `productivity`, `tooling`, `culture`, `metrics`.
4. Default `commentary` to a neutral TL;DR, not a first-person personal note.
   Only write it in the blog author's voice if the user explicitly provides or asks for that.
5. Create the entry file and keep the body optional. If there is a strong excerpt, put it in `quote`; do not paste large chunks of the source.

### If the user provides a GitHub issue or issue body

1. Treat the issue as intake context, not publish-ready copy.
2. Use the submitted URL as the source of truth for title, source metadata, and dates when possible.
3. Preserve any submitter-provided TL;DR or relevance notes only as raw input to refine; do not present them as the blog author's personal note unless explicitly approved.
4. Keep the final `commentary` field neutral by default.
5. Reuse suggested tags when they fit the section's existing conventions.

### If the user does not provide a URL

1. Derive a slug from the title.
2. Use the provided metadata.
3. Leave unknown optional fields blank rather than inventing them.
4. If the user asks for a TL;DR, keep it neutral and concise.
5. If the user wants a personal note, use only wording the user provided or approved.

## Writing rules

- Use `commentary` as a short TL;DR by default. Usually 1-3 sentences.
- Do not invent personal opinions, reactions, or first-person framing.
- Do not treat issue submitter text as the maintainer's voice unless the maintainer explicitly says to publish it that way.
- Prefer paraphrase over long quotation.
- Keep tags source-aware and sparse.
- Use `type` values that match the section conventions: `tweet`, `blog-post`, `podcast`, `interview`, `talk`, `paper`, `other`.
- Do not build import automation, scraping pipelines, or extra taxonomy pages as part of adding an entry.

## Verification

- If you changed templates, front matter shape, or rendering-related fields, run the site build after editing.
- If you only added a content file and the existing schema already supports it, a full build is still preferred before wrapping up.
