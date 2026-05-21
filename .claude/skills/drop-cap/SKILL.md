---
name: drop-cap
description: >-
  Add an illuminated drop cap to the first letter of a blog post in this
  Hakyll blog (twitchard.github.io). Use when publishing a post in posts/,
  when a prose post is missing its opening drop cap, or when asked to add or
  fix a drop cap. Every class:prose post opens with one.
---

# Drop cap

Every `class: prose` post on this blog opens with a decorative **drop cap** —
the first letter of the first paragraph rendered as an image that floats to
the left. `class: poetry` posts do **not** get a drop cap.

## The standard markup

Replace the first letter of the first body paragraph with an `<img>` tag, then
leave the rest of the word as text:

```
<img src="../images/dropcap-<letter>.jpg" class="dropCap" alt="<LETTER>" />est of word...
```

Rules that must hold (the CI check in `scripts/check_post_metadata.py` and the
CSS in `css/default.css` depend on them):

- The `class` attribute must be exactly `dropCap`.
- The `src` is relative to the post: `../images/...`.
- The `alt` is the single uppercase letter.
- The drop cap must appear in the **first paragraph** of the body. A heading
  (`## ...`) or an italic epigraph may legitimately come before it — that is
  fine, the check allows the first ~1200 characters.

### Worked examples

First paragraph begins `Say you've got a public REST API...`:

```
<img src="../images/dropcap-s.jpg" class="dropCap" alt="S" />ay you've got a public REST API...
```

First paragraph begins `I recently had the pleasure...` (the first letter is a
whole word — keep the following space):

```
<img src="../images/dropcap-i.jpg" class="dropCap" alt="I" /> recently had the pleasure...
```

## Choosing the image

1. **Default set** — `images/dropcap-a.jpg` … `images/dropcap-z.jpg` is a
   complete A–Z set of public-domain decorative initials from "The Landscape
   Alphabet" (each letter formed from a landscape scene), sourced from
   Wikimedia Commons. See `images/DROPCAPS.md` for attribution. There is
   always an image for every letter, so a drop cap can always be added
   automatically.
2. **Custom drop cap** — some posts use a hand-picked, post-specific image
   (e.g. `images/dropCapPairProgramming.png`). If the author has chosen one,
   keep it. Only fall back to the default set when no custom image is wanted.

Whatever image you use, confirm the file exists in `images/` before saving.

## After adding a drop cap

Run the check on the post to confirm it passes:

```
python3 scripts/check_post_metadata.py posts/<the-post>.md
```
