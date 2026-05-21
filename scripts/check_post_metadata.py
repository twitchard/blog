#!/usr/bin/env python3
"""Validate SEO metadata on blog posts.

Enforces that every non-draft post in posts/ carries the metadata the
templates and search engines need before it can be published. Draft posts
(draft: true) are skipped.

Usage:
    scripts/check_post_metadata.py                # check every post
    scripts/check_post_metadata.py posts/foo.md   # check specific posts

Exit status is non-zero if any ERROR-level problem is found, which fails CI.
"""

import os
import re
import sys
import glob

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
IMAGES_DIR = os.path.join(REPO_ROOT, "images")

# Descriptions that are placeholders rather than real, post-specific summaries.
GENERIC_DESCRIPTIONS = {
    "richard's software blog",
    "richards software blog",
}

DESCRIPTION_MIN = 50
DESCRIPTION_MAX = 200
DESCRIPTION_IDEAL_MAX = 160
TITLE_IDEAL_MAX = 60
KNOWN_CLASSES = {"prose", "poetry"}

# How far into the body a drop cap is allowed to appear (a heading and/or an
# epigraph may legitimately precede the first real paragraph).
DROP_CAP_WINDOW = 1200


def parse_frontmatter(text):
    """Return (metadata dict, body string). metadata is None if no frontmatter."""
    lines = text.split("\n")
    if not lines or lines[0].strip() != "---":
        return None, text
    end = None
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            end = i
            break
    if end is None:
        return None, text

    meta = {}
    for raw in lines[1:end]:
        if not raw.strip() or raw.lstrip().startswith("#"):
            continue
        m = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", raw)
        if not m:
            continue
        key = m.group(1)
        val = m.group(2).strip()
        if len(val) >= 2 and val[0] == '"' and val[-1] == '"':
            val = val[1:-1].replace('\\"', '"')
        elif len(val) >= 2 and val[0] == "'" and val[-1] == "'":
            val = val[1:-1]
        meta[key] = val
    body = "\n".join(lines[end + 1:])
    return meta, body


def is_draft(meta):
    return str(meta.get("draft", "")).strip().lower() == "true"


def image_path_from_reference(ref):
    """Map an image reference like ../images/foo.png or a thumbnail URL to a
    repo-relative file path under images/, or None if it is not a local image."""
    m = re.search(r"/?images/([^\s\"')}]+)", ref)
    if not m:
        return None
    return os.path.join(IMAGES_DIR, m.group(1))


def find_drop_cap(body):
    """Return (found, image_reference_or_None) for a drop cap near the start."""
    window = body[:DROP_CAP_WINDOW]
    if "dropcap" not in window.lower():
        return False, None
    # Pull the local image reference out of the drop cap markup.
    idx = window.lower().find("dropcap")
    region = window[max(0, idx - 200): idx + 200]
    m = re.search(r"\.\./images/[^\s\"')}]+", region)
    return True, (m.group(0) if m else None)


def check_post(path, errors, warnings):
    rel = os.path.relpath(path, REPO_ROOT)
    with open(path, encoding="utf-8") as f:
        text = f.read()

    meta, body = parse_frontmatter(text)
    if meta is None:
        errors.append((rel, 1, "missing YAML frontmatter (--- ... ---)"))
        return
    if is_draft(meta):
        return  # drafts are exempt until published

    def err(msg):
        errors.append((rel, 1, msg))

    def warn(msg):
        warnings.append((rel, 1, msg))

    # --- title -------------------------------------------------------------
    title = meta.get("title", "").strip()
    if not title:
        err("missing required field: title")
    elif len(title) > TITLE_IDEAL_MAX:
        warn("title is %d chars; keep under %d so it is not truncated in "
             "search results" % (len(title), TITLE_IDEAL_MAX))

    # --- description -------------------------------------------------------
    description = meta.get("description", "").strip()
    if not description:
        err("missing required field: description")
    else:
        if description.lower() in GENERIC_DESCRIPTIONS:
            err("description is a generic placeholder (%r); write a "
                "post-specific summary" % description)
        elif len(description) < DESCRIPTION_MIN:
            err("description is %d chars; must be at least %d for a useful "
                "search snippet" % (len(description), DESCRIPTION_MIN))
        elif len(description) > DESCRIPTION_MAX:
            err("description is %d chars; must be at most %d"
                % (len(description), DESCRIPTION_MAX))
        elif len(description) > DESCRIPTION_IDEAL_MAX:
            warn("description is %d chars; search engines may truncate past "
                 "~%d" % (len(description), DESCRIPTION_IDEAL_MAX))

    # --- class -------------------------------------------------------------
    post_class = meta.get("class", "").strip()
    if not post_class:
        err("missing required field: class (e.g. prose or poetry)")
    elif post_class not in KNOWN_CLASSES:
        warn("class is %r; expected one of %s"
             % (post_class, ", ".join(sorted(KNOWN_CLASSES))))

    # --- quote (used for prev/next teasers) --------------------------------
    if post_class == "prose" and not meta.get("quote", "").strip():
        err("missing required field: quote (prose posts need a pull-quote)")

    # --- drop cap (prose posts) -------------------------------------------
    if post_class == "prose":
        found, ref = find_drop_cap(body)
        if not found:
            err("no drop cap found near the start of the body; every prose "
                "post opens with a drop cap (see .claude/skills/drop-cap)")
        elif ref:
            img = image_path_from_reference(ref)
            if img and not os.path.isfile(img):
                err("drop cap image not found: %s" % ref)

    # --- thumbnail (og:image) ---------------------------------------------
    thumbnail = meta.get("thumbnail", "").strip()
    if not thumbnail:
        warn("no thumbnail set; the post will have no social-share image "
             "(og:image / twitter:image)")
    else:
        img = image_path_from_reference(thumbnail)
        if img and not os.path.isfile(img):
            err("thumbnail image not found: %s" % thumbnail)


def main(argv):
    if argv:
        paths = [os.path.abspath(p) for p in argv]
    else:
        paths = sorted(glob.glob(os.path.join(REPO_ROOT, "posts", "*.md")))

    errors = []
    warnings = []
    for path in paths:
        check_post(path, errors, warnings)

    for rel, line, msg in warnings:
        print("::warning file=%s,line=%d::%s" % (rel, line, msg))
        print("  WARN  %s: %s" % (rel, msg))
    for rel, line, msg in errors:
        print("::error file=%s,line=%d::%s" % (rel, line, msg))
        print("  ERROR %s: %s" % (rel, msg))

    print()
    print("Checked %d post(s): %d error(s), %d warning(s)."
          % (len(paths), len(errors), len(warnings)))
    if errors:
        print("Metadata check FAILED. Fix the errors above before publishing.")
        return 1
    print("Metadata check passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
