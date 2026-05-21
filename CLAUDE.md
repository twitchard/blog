# CLAUDE.md

Richard Marmorstein's software blog, published at https://twitchard.github.io.

## Stack

- **Hakyll** (Haskell static site generator). Site rules live in `site.hs`.
- Built with **Nix**: `nix-build` produces `result/bin/site`, then
  `result/bin/site build` writes `_site/`.
- Posts are Markdown with YAML frontmatter in `posts/` (`YYYY-MM-DD-slug.md`).
- Templates are in `templates/`; styles in `css/`; images in `images/`.

## Posts and metadata

Every post needs frontmatter. Required for non-draft posts: `title`,
`description`, `class` (`prose` or `poetry`), and `quote` (prose only).
`thumbnail` is recommended. See the `post-metadata` skill for the full spec.

`class: prose` posts open with a decorative **drop cap** image — see the
`drop-cap` skill. A complete A–Z set lives at `images/dropcap-a.jpg` …
`images/dropcap-z.jpg` (`images/DROPCAPS.md` has attribution).

## SEO

SEO meta tags (Open Graph, Twitter Card, canonical, JSON-LD) are centralized in
`templates/default.html` and `templates/post.html` — they read post
frontmatter, so keeping frontmatter complete keeps SEO correct. `site.hs`
generates `sitemap.xml` and copies `robots.txt`.

## CI / publishing

`.github/workflows/main.yml` has two jobs:

1. `validate` — runs `python3 scripts/check_post_metadata.py`, which fails the
   build if any non-draft post is missing required metadata or a drop cap.
2. `build` — `needs: validate`; builds the site and deploys to
   `twitchard.github.io` only from the `master` branch.

So a non-draft post cannot go live until its metadata check passes.

## Skills

- `publish-post` — take a post from draft to publishable end to end.
- `post-metadata` — generate/validate frontmatter (description, quote, …).
- `drop-cap` — add the opening drop cap to a prose post.

## Local commands

```
nix-build && result/bin/site build   # build the site into _site/
result/bin/site watch                # preview locally
python3 scripts/check_post_metadata.py   # validate all posts
./auto build                         # build via the helper script
```
