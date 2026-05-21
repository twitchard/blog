---
name: publish-post
description: >-
  Publish a blog post in this Hakyll blog (twitchard.github.io) end to end:
  fill in SEO metadata, add the opening drop cap, validate, and flip the post
  out of draft. Use when asked to publish a post, mark a draft ready, or get a
  post ready to go live.
---

# Publish a post

Use this checklist to take a post in `posts/` from draft to publishable. It
ties together the `post-metadata` and `drop-cap` skills and the CI check.

## Steps

1. **Read the post.** Read the full body so the metadata and drop cap are
   accurate.

2. **Complete the metadata.** Apply the `post-metadata` skill. Ensure
   `title`, `description`, `class`, and (for `prose`) `quote` are all present
   and post-specific. Add a `thumbnail` if the post has a suitable image.

3. **Add the drop cap.** For a `class: prose` post, apply the `drop-cap`
   skill so the first paragraph opens with a drop cap. Skip this for
   `class: poetry`.

4. **Leave draft status undecided to the user.** Do **not** flip `draft` to
   `false` or remove it unless the user explicitly says to publish. Publishing
   makes the post live on the next deploy — confirm intent first. When
   confirmed, set `draft: false` or delete the `draft` line.

5. **Validate.** Run the metadata check and fix every `ERROR`:

   ```
   python3 scripts/check_post_metadata.py posts/<the-post>.md
   ```

6. **Build if possible.** If the Haskell toolchain is available, do a local
   build to confirm nothing broke:

   ```
   nix-build && result/bin/site build
   ```

   If the toolchain is not available, say so rather than claiming the build
   passed — CI will run the full build on push.

7. **Report.** Summarize what metadata was added/changed and whether the
   post is now draft or live.

## How publishing actually happens

`.github/workflows/main.yml` runs `validate` (the metadata check) on every
push. `build` depends on `validate`, so a post with missing metadata cannot be
built or deployed. Deployment to `twitchard.github.io` happens only when the
`master` branch builds successfully. A non-draft post therefore cannot go live
until its metadata is complete.
