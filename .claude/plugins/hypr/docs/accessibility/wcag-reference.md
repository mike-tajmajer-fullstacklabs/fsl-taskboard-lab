# WCAG 2.1 Quick Reference

All 78 success criteria by conformance level.

## Level A (30 criteria)

### Perceivable

| ID | Name | Requirement |
|----|------|-------------|
| 1.1.1 | Non-text Content | Images have alt text |
| 1.2.1 | Audio-only/Video-only | Provide transcripts |
| 1.2.2 | Captions (Prerecorded) | Videos have captions |
| 1.2.3 | Audio Description | Video has description or transcript |
| 1.3.1 | Info and Relationships | Use semantic HTML |
| 1.3.2 | Meaningful Sequence | DOM order = visual order |
| 1.3.3 | Sensory Characteristics | Don't rely only on shape/color |
| 1.4.1 | Use of Color | Color not sole indicator |
| 1.4.2 | Audio Control | Can pause auto-playing audio |

### Operable

| ID | Name | Requirement |
|----|------|-------------|
| 2.1.1 | Keyboard | All features work with keyboard |
| 2.1.2 | No Keyboard Trap | Can tab away from everything |
| 2.1.4 | Character Key Shortcuts | Can disable single-key shortcuts |
| 2.2.1 | Timing Adjustable | Can extend time limits |
| 2.2.2 | Pause, Stop, Hide | Can pause moving content |
| 2.3.1 | Three Flashes | No fast flashing content |
| 2.4.1 | Bypass Blocks | Skip link or landmarks |
| 2.4.2 | Page Titled | Descriptive page title |
| 2.4.3 | Focus Order | Logical tab order |
| 2.4.4 | Link Purpose | Link text describes destination |
| 2.5.1 | Pointer Gestures | Single-point alternatives |
| 2.5.2 | Pointer Cancellation | Click on up-event |
| 2.5.3 | Label in Name | Accessible name = visible text |
| 2.5.4 | Motion Actuation | Alternatives to shake/tilt |

### Understandable

| ID | Name | Requirement |
|----|------|-------------|
| 3.1.1 | Language of Page | `<html lang="en">` |
| 3.2.1 | On Focus | Focus doesn't change context |
| 3.2.2 | On Input | Input doesn't change context |
| 3.3.1 | Error Identification | Errors clearly described |
| 3.3.2 | Labels or Instructions | Inputs have labels |

### Robust

| ID | Name | Requirement |
|----|------|-------------|
| 4.1.2 | Name, Role, Value | Custom components have ARIA |

---

## Level AA (20 criteria)

### Perceivable

| ID | Name | Requirement |
|----|------|-------------|
| 1.2.4 | Captions (Live) | Live video has captions |
| 1.2.5 | Audio Description | Video has audio description |
| 1.3.4 | Orientation | Works portrait and landscape |
| 1.3.5 | Identify Input Purpose | Use autocomplete attributes |
| 1.4.3 | Contrast (Minimum) | 4.5:1 text, 3:1 large text |
| 1.4.4 | Resize Text | Works at 200% zoom |
| 1.4.5 | Images of Text | Use real text, not images |
| 1.4.10 | Reflow | No horizontal scroll at 320px |
| 1.4.11 | Non-text Contrast | 3:1 for UI components |
| 1.4.12 | Text Spacing | Works with increased spacing |
| 1.4.13 | Content on Hover/Focus | Dismissible and persistent |

### Operable

| ID | Name | Requirement |
|----|------|-------------|
| 2.4.5 | Multiple Ways | Multiple ways to find pages |
| 2.4.6 | Headings and Labels | Descriptive headings |
| 2.4.7 | Focus Visible | Visible focus indicator |
| 2.5.7 | Dragging Movements | Click alternative to drag |
| 2.5.8 | Target Size (Minimum) | 24x24px minimum |

### Understandable

| ID | Name | Requirement |
|----|------|-------------|
| 3.2.3 | Consistent Navigation | Same nav order on all pages |
| 3.2.4 | Consistent Identification | Same labels for same functions |
| 3.3.3 | Error Suggestion | Suggest how to fix errors |
| 3.3.4 | Error Prevention | Can review before submit |

### Robust

| ID | Name | Requirement |
|----|------|-------------|
| 4.1.3 | Status Messages | Use aria-live for updates |

---

## Level AAA (28 criteria)

### Perceivable

| ID | Name | Requirement |
|----|------|-------------|
| 1.2.6 | Sign Language | Sign language for video |
| 1.2.7 | Extended Audio Description | Extended descriptions |
| 1.2.8 | Media Alternative | Full transcripts for video |
| 1.2.9 | Audio-only (Live) | Live transcripts |
| 1.3.6 | Identify Purpose | All regions have landmarks |
| 1.4.6 | Contrast (Enhanced) | 7:1 text, 4.5:1 large |
| 1.4.7 | Low Background Audio | Minimal background noise |
| 1.4.8 | Visual Presentation | Max 80 chars, good spacing |
| 1.4.9 | Images of Text (No Exception) | No text images except logos |

### Operable

| ID | Name | Requirement |
|----|------|-------------|
| 2.1.3 | Keyboard (No Exception) | Everything keyboard accessible |
| 2.2.3 | No Timing | No time limits |
| 2.2.4 | Interruptions | Can postpone interruptions |
| 2.2.5 | Re-authenticating | Preserve data on timeout |
| 2.3.2 | Three Flashes | No flashing at all |
| 2.3.3 | Animation from Interactions | Can disable animations |
| 2.4.8 | Location | Breadcrumbs present |
| 2.4.9 | Link Purpose (Link Only) | Link text alone is clear |
| 2.4.10 | Section Headings | Content has section headings |
| 2.5.5 | Target Size | 44x44px minimum |
| 2.5.6 | Concurrent Input | Multiple input methods work |

### Understandable

| ID | Name | Requirement |
|----|------|-------------|
| 3.1.2 | Language of Parts | `lang` on foreign text |
| 3.1.3 | Unusual Words | Define jargon/idioms |
| 3.1.4 | Abbreviations | Expand abbreviations |
| 3.1.5 | Reading Level | Simple language version |
| 3.1.6 | Pronunciation | Pronunciation for ambiguous words |
| 3.2.5 | Change on Request | User initiates all changes |
| 3.3.5 | Help | Context-sensitive help |
| 3.3.6 | Error Prevention (All) | Review before all submissions |

---

## Most Common Failures

| Issue | Criterion | Found on % of sites |
|-------|-----------|---------------------|
| Low contrast text | 1.4.3 | 83% |
| Missing alt text | 1.1.1 | 55% |
| Empty links | 2.4.4 | 50% |
| Missing form labels | 3.3.2 | 46% |
| Empty buttons | 4.1.2 | 28% |
| Missing lang attribute | 3.1.1 | 18% |

---

## Resources

- [WCAG 2.1 Specification](https://www.w3.org/TR/WCAG21/)
- [WCAG Quick Reference](https://www.w3.org/WAI/WCAG21/quickref/)
- [WebAIM Checklist](https://webaim.org/standards/wcag/checklist)
