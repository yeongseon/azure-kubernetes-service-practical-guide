---
description: Information architecture convention for Azure practical guide repos — keep MkDocs navigation within budget, collapse deep inventories into hub pages, and preserve discoverability.
---

# Navigation IA Convention

Use this convention to keep MkDocs navigation readable as the guide grows. The goal is to make the left nav useful for orientation without hiding any content from readers or from `mkdocs build --strict`.

## Navigation Budget

Apply these limits to every Azure practical guide repository:

- Top-level navigation items: 6-9
- Direct children under a top-level section: 5-8

Treat the budget as an information-architecture guardrail, not as a suggestion. If a section grows past the budget, reorganize it before adding more literal nav leaves.

## When to Sub-Group

Sub-group pages when readers benefit from browsing a stable hierarchy.

Good candidates:

- **Platform** sections with durable concept families such as architecture, networking, storage, identity, and scaling
- **Best Practices** sections with stable operational themes such as security, reliability, networking, and cost
- **Operations** sections where readers navigate recurring procedural domains such as upgrades, observability, backup, and scaling

Use sub-groups when the grouping is likely to stay valid across future additions. The grouping should help a reader predict where the next page belongs.

## When to Collapse to a Hub Page

Collapse large or fast-growing inventories out of the literal nav and keep only their hub pages or subcategory indexes in nav.

Good candidates:

- Playbooks
- KQL query packs
- Labs and fault-injection inventories
- Recipes and tutorial catalogs
- Generated reference collections

Use this pattern when the reader usually enters through a category page, search, or a scenario router instead of scanning dozens of sibling leaves in the nav.

## How Discoverability Stays Intact

Collapsing leaves out of nav does not mean hiding them.

Hub pages must provide a complete inventory of every collapsed leaf through a table, checklist, or link list. If a page is removed from literal nav, it must still be reachable from:

1. Its section hub page
2. Its subcategory index page when the inventory is split by category
3. Site search, which supplements the curated navigation path

Before merging a nav cleanup, verify that no collapsed leaf became orphaned.

## Using `not_in_nav`

Use MkDocs core `not_in_nav` for linkable pages that intentionally stay out of literal navigation. `not_in_nav` accepts gitignore-style patterns and suppresses omitted-file warnings during `mkdocs build --strict`.

```yaml
not_in_nav: |
  /troubleshooting/playbooks/*.md
  /troubleshooting/playbooks/*/*.md
  /troubleshooting/kql/*/*.md
```

Use `not_in_nav` when a page should still build, resolve links, and remain searchable.

Do **not** use `exclude_docs` for these cases. `exclude_docs` removes pages from the site output entirely, which breaks the hub-page pattern for linkable inventories.

## Contributor Checklist for New Deep-Inventory Pages

Before adding a new page to a large inventory:

1. Check whether the parent section is already at or near the navigation budget.
2. If the inventory is large or still growing, keep the new leaf out of literal nav.
3. Add the leaf to the appropriate hub index or subcategory index the same time you add the page.
4. Make sure the `not_in_nav` patterns still cover the new file path.
5. Run `.venv-omo/bin/mkdocs build --strict` and confirm zero warnings.

## Portable Rule Across Sibling Repositories

This pattern is portable across the Azure practical guide series. Each repository can choose its own section names and sub-groups, but the same rule applies: keep navigation shallow enough for orientation, and move large inventories behind strong hub pages instead of expanding the nav indefinitely.

## See Also

- [Contributing](index.md)
- [Playbooks](../troubleshooting/playbooks/index.md)
