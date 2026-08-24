# Vendored plugins

## hypr

A pinned copy of the Hypr framework, bundled so Lab 3 works without access to
its private marketplace.

- Upstream: `FullStack-Engineering/hypr-framework`
- Pinned at: `c0a84e6` ("update the hypr framework to current standards", #10) — plugin version 1.1.0
- Local modification: `.claude-plugin/marketplace.json` `name` is `hypr-lab`
  instead of `hypr`, so this copy can coexist with the real marketplace on a
  machine that already has it. The plugin itself is still named `hypr`, so its
  commands stay `/hypr:*`.

Install it with `npm run hypr:setup` from the repo root. Prettier is told to
skip this directory (see `.prettierignore`) so the copy doesn't drift from
upstream.

### Refreshing it

```bash
rm -rf .claude/plugins/hypr
cp -R <path-to-hypr-framework-checkout> .claude/plugins/hypr
rm -rf .claude/plugins/hypr/.git
# re-apply the marketplace rename, then:
claude plugin marketplace update hypr-lab && claude plugin update hypr@hypr-lab
```
