---
paths:
  - "**/*.{tsx,jsx,vue,svelte,html,css,scss}"
---

# Accessibility Rules

WCAG 2.1 AA standards for code generation. Follow these rules for all UI code.
These are `rule` blocks per the format in `docs/rules-format.md`; the `example`
field cites the governing WCAG success criterion. The `paths:` frontmatter above
scopes the set to UI files, so when this file is installed at
`.claude/rules/accessibility.md` Claude loads it only when editing UI code.

## Semantic HTML

```rule
id: A11Y-001
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Use <button> for clickable actions, never <div> or <span> with onClick.
example: WCAG 4.1.2
check: ast-grep
```

```rule
id: A11Y-002
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Use <a> for navigation links, never <div> or <span> with onClick.
example: WCAG 4.1.2
check:
```

```rule
id: A11Y-003
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Use heading hierarchy correctly (h1 > h2 > h3) and never skip levels.
example: WCAG 1.3.1
check:
```

```rule
id: A11Y-004
severity: warn
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Use landmark elements (<main>, <nav>, <header>, <footer>, <aside>) to structure the page.
example: WCAG 1.3.1
check:
```

```rule
id: A11Y-005
severity: warn
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Use <ul> or <ol> for lists of related items, not divs.
example: WCAG 1.3.1
check:
```

## Forms

```rule
id: A11Y-006
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Every input must have a visible <label> element.
example: WCAG 3.3.2
check:
```

```rule
id: A11Y-007
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Associate labels with inputs via htmlFor/id.
example: WCAG 1.3.1
check:
```

```rule
id: A11Y-008
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Never use placeholder text as the only label.
example: WCAG 3.3.2
check:
```

```rule
id: A11Y-009
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Mark required fields with aria-required="true" AND a visible indicator.
example: WCAG 3.3.2
check:
```

```rule
id: A11Y-010
severity: warn
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Group related inputs with <fieldset> and <legend>.
example: WCAG 1.3.1
check:
```

```rule
id: A11Y-011
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Link error messages to inputs with aria-describedby.
example: WCAG 3.3.1
check:
```

```rule
id: A11Y-012
severity: warn
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Use appropriate input types (email, tel, url, number, password).
example: WCAG 1.3.5
check:
```

```rule
id: A11Y-013
severity: warn
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Add autocomplete attributes for common fields (email, name, address, etc.).
example: WCAG 1.3.5
check:
```

## Keyboard Accessibility

```rule
id: A11Y-014
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: All interactive elements must be keyboard accessible.
example: WCAG 2.1.1
check:
```

```rule
id: A11Y-015
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Tab order must follow logical reading order.
example: WCAG 2.4.3
check:
```

```rule
id: A11Y-016
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html,css,scss}
statement: Focus indicators must be visible; never use outline:none without a replacement.
example: WCAG 2.4.7
check:
```

```rule
id: A11Y-017
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Custom components need keyboard handlers for Enter, Space, Escape, and Arrow keys.
example: WCAG 2.1.1
check:
```

```rule
id: A11Y-018
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: No keyboard traps; users must be able to tab away from any element.
example: WCAG 2.1.2
check:
```

```rule
id: A11Y-019
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Modals must trap focus while open and return focus to the trigger when closed.
example: WCAG 2.4.3
check:
```

## Images and Media

```rule
id: A11Y-020
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: All images must have an alt attribute.
example: WCAG 1.1.1
check: ast-grep
```

```rule
id: A11Y-021
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: For informative images, the alt attribute describes the content.
example: WCAG 1.1.1
check:
```

```rule
id: A11Y-022
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: For decorative images, use alt="" (empty string).
example: WCAG 1.1.1
check:
```

```rule
id: A11Y-023
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Icons with meaning need accessible text (aria-label or visually hidden text).
example: WCAG 1.1.1
check:
```

```rule
id: A11Y-024
severity: warn
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Decorative icons use aria-hidden="true".
example: WCAG 1.1.1
check:
```

## ARIA

```rule
id: A11Y-025
severity: info
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Use ARIA only when native HTML is insufficient.
example: WCAG 4.1.2
check:
```

```rule
id: A11Y-026
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Custom components must have appropriate role attributes.
example: WCAG 4.1.2
check:
```

```rule
id: A11Y-027
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Interactive components must have aria-expanded, aria-selected, etc. as needed.
example: WCAG 4.1.2
check:
```

```rule
id: A11Y-028
severity: warn
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Use aria-label only when visible text is insufficient.
example: WCAG 4.1.2
check:
```

```rule
id: A11Y-029
severity: info
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Use aria-describedby to provide additional context.
example: WCAG 1.3.1
check:
```

```rule
id: A11Y-030
severity: warn
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Use aria-live="polite" to announce dynamic content changes.
example: WCAG 4.1.3
check:
```

```rule
id: A11Y-031
severity: warn
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Use aria-live="assertive" only for critical alerts.
example: WCAG 4.1.3
check:
```

## Color and Contrast

```rule
id: A11Y-032
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html,css,scss}
statement: Text contrast must be at least 4.5:1 (3:1 for large text 18px+ or 14px bold).
example: WCAG 1.4.3
check:
```

```rule
id: A11Y-033
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html,css,scss}
statement: UI component contrast must be at least 3:1.
example: WCAG 1.4.11
check:
```

```rule
id: A11Y-034
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html,css,scss}
statement: Never use color alone to convey information; add icons, text, or patterns.
example: WCAG 1.4.1
check:
```

```rule
id: A11Y-035
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html,css,scss}
statement: Focus indicators must have 3:1 contrast against the background.
example: WCAG 1.4.11
check:
```

## Dynamic Content

```rule
id: A11Y-036
severity: warn
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Announce loading states to screen readers.
example: WCAG 4.1.3
check:
```

```rule
id: A11Y-037
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Announce errors with role="alert" or aria-live.
example: WCAG 4.1.3
check:
```

```rule
id: A11Y-038
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Manage focus when content changes (modals, page transitions, deletions).
example: WCAG 2.4.3
check:
```

```rule
id: A11Y-039
severity: warn
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Single-page navigation must announce new page content.
example: WCAG 4.1.3
check:
```

## Touch and Pointer

```rule
id: A11Y-040
severity: error
scope: **/*.{tsx,jsx,vue,svelte,html,css,scss}
statement: Touch targets must be at least 44x44 CSS pixels.
example: WCAG 2.5.5
check:
```

```rule
id: A11Y-041
severity: warn
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Provide alternatives to drag-and-drop interactions.
example: WCAG 2.5.7
check:
```

```rule
id: A11Y-042
severity: warn
scope: **/*.{tsx,jsx,vue,svelte,html}
statement: Ensure click actions fire on pointer up, not down (allows cancel).
example: WCAG 2.5.2
check:
```
