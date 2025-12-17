# Rust Lambda Build Base Image

Base Docker image for building AWS Lambda functions written in Rust.
Includes cargo-lambda, cargo-chef, sccache, and mold.

For BuddyCompass.

## Versioning policy

- Image tags follow the cargo-lambda version.
- Tool versions may be updated in minor releases.

## Memo: How to release

1. Create a release branch from `develop`:
   ```bash
   git checkout develop
   git pull
   git checkout -b release/v1.7.0
   ```

2. Prepare for release (update versions, etc.) and commit changes

3. Merge to `main`:
   ```bash
   git checkout main
   git pull
   git merge --no-ff release/v1.7.0
   git push origin main
   ```

4. Create a GitHub Release from `main`:
   ```bash
   git checkout main
   gh release create v1.7.0 --generate-notes
   ```
   Or manually via GitHub UI: Releases → "Create a new release"

5. Merge back to `develop`:
   ```bash
   git checkout develop
   git merge --no-ff main
   git push origin develop
   ```

6. Delete the release branch:
   ```bash
   git branch -d release/v1.7.0
   ```

7. GitHub Actions will automatically build and push the image to GHCR with tags:
   - `ghcr.io/[owner]/bc-cargo-lambda-with-cache:v1.7.0`
   - `ghcr.io/[owner]/bc-cargo-lambda-with-cache:v1.7`
   - `ghcr.io/[owner]/bc-cargo-lambda-with-cache:v1`


## Notes

Although this image could be made a private image, since there are no costs for GitHub's Container registry, it is kept public.