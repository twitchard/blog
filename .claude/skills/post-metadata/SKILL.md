---
name: post-metadata
description: >-
  Generate, extract, and validate the SEO frontmatter metadata (title,
  description, quote, class, thumbnail) for a blog post in this Hakyll blog
  (twitchard.github.io). Use when creating a new post, or when a post is
  missing required metadata, or when asked to write a description or quote.
---

# Post metadata

Every post in `posts/` starts with YAML frontmatter between `---` lines. The
templates (`templates/default.html`, `templates/post.html`) and search engines
depend on these fields. `scripts/check_post_metadata.py` enforces them for
every non-draft post.

## Fields

| Field | Required | Purpose / rules |
|-------|----------|-----------------|
| `title` | yes | Post title. Feeds `<title>`, `og:title`, `twitter:title`, JSON-LD `headline`. Aim for ≤ 60 characters so it is not truncated in search results. |
| `description` | yes | One-sentence, **post-specific** summary. Feeds `<meta name="description">`, `og:description`, `twitter:description`, JSON-LD. Must be 50–200 characters; aim for 50–160. Never a generic placeholder like "Richard's Software Blog". |
| `class` | yes | `prose` for essays, `poetry` for poems. Controls styling and whether a drop cap is required. |
| `quote` | yes for `prose` | A short, striking pull-quote drawn from the post. Shown as a teaser in the previous/next-post links and the Atom feed. |
| `thumbnail` | recommended | Full URL of the social-share image, e.g. `https://twitchard.github.io/images/<file>`. Feeds `og:image` / `twitter:image` and upgrades the Twitter card to `summary_large_image`. Without it the post has no share image. |
| `draft` | optional | `true` while drafting. Draft posts are excluded from the index, Atom feed, and sitemap, marked `noindex`, and skipped by the metadata check. Remove it (or set `false`) to publish. |
| `reddit`, `hackernews`, `retweet` | optional | Discussion-link URLs; render as a call to action at the foot of the post. |

## Generating metadata for a post

Read the full post body, then:

- **description** — Summarize the post's central claim in one clear sentence
  aimed at a reader scanning search results. Make it specific to *this* post.
  Keep it 50–160 characters. Do not just repeat the title.
- **quote** — Pick a single vivid, self-contained line from the body (often
  the thesis or a memorable turn of phrase). It should make sense out of
  context and entice a click.
- **thumbnail** — If the post has a hero image, point `thumbnail` at it as a
  full `https://twitchard.github.io/images/...` URL. If not, suggest one.
- **title** — If it runs long, see whether a tighter phrasing fits in ≤ 60
  characters, but never distort the author's meaning.

YAML notes: wrap a value in double quotes if it contains a colon; escape any
inner double quote as `\"`.

## Validating

After editing frontmatter, run:

```
python3 scripts/check_post_metadata.py posts/<the-post>.md
```

Fix every `ERROR`. `WARN` lines are advisory (e.g. a missing thumbnail) and do
not fail CI, but address them when you reasonably can.
