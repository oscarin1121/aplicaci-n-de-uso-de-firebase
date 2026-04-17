# Design System Specification: The Kinetic Developer

## 1. Overview & Creative North Star

### Creative North Star: "The Architectural IDE"
This design system moves away from the "flatness" of standard productivity apps to embrace a high-end, editorial-developer aesthetic. It draws inspiration from modern Integrated Development Environments (IDEs) and high-end technical journals. Instead of generic templates, we utilize **Intentional Asymmetry** and **Tonal Depth** to guide the user's eye. 

The goal is to make a "To-Do manager" feel like a sophisticated command center. We break the grid by using oversized `display` typography against condensed `label` data, creating a rhythmic contrast that feels both premium and functional.

---

## 2. Colors & Surface Philosophy

The palette is anchored in Firebase’s DNA but elevated through a "Deep Ink" dark mode. We use high-contrast primary accents against a sophisticated range of charcoal and obsidian surfaces.

### The "No-Line" Rule
**Strict Mandate:** Designers are prohibited from using 1 px solid borders for sectioning. 
Structure is defined through **Tonal Transitions**. To separate a sidebar from a main feed, transition from `surface` (#131313) to `surface-container-low` (#1C1B1B). This creates a seamless, "molded" look rather than a "boxed" one.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Use the hierarchy below to define importance:
*   **Background Layer:** `surface` (#131313) – The base canvas.
*   **Mid-Ground:** `surface-container` (#201F1F) – Standard groupings or cards.
*   **High-Ground:** `surface-container-highest` (#353534) – Active elements or focused tasks.

### The "Glass & Gradient" Rule
To add "soul" to the developer experience, use Glassmorphism for floating panels (e.g., Command Palettes). 
*   **Floating Elements:** Apply `surface_variant` at 60% opacity with a `24px` backdrop blur.
*   **Signature Textures:** For main CTAs, use a subtle linear gradient from `primary` (#F3C01A) to `primary_container` (#B68D00) at a 135° angle.

---

## 3. Typography

The system utilizes a tri-font pairing to distinguish between "Action," "Content," and "Data."

| Role | Font Family | Usage | Personality |
| :--- | :--- | :--- | :--- |
| **Display/Headline** | `Space Grotesk` | Large headers, Task counts | Technical, geometric, bold. |
| **Title/Body** | `Manrope` | Task names, Descriptions | Humanist, highly readable, clean. |
| **Labels/Code** | `Inter` | Metadata, Tags, Timestamps | Functional, neutral, professional. |

**Editorial Contrast:** Pair a `display-lg` task count (Space Grotesk) directly adjacent to a `label-md` status tag (Inter). This scale shift creates a sophisticated, "magazine-style" layout for a simple list.

---

## 4. Elevation & Depth

We move beyond Material Design’s standard shadows in favor of **Tonal Layering**.

*   **The Layering Principle:** A task card should not have a shadow. Instead, place a `surface-container-low` card on top of the `surface` background. To show "Hover" states, shift the card to `surface-container-high`.
*   **Ambient Shadows:** For high-level modals, use a "Shadow Tint." The shadow should be `primary_container` at 8% opacity with a `48px` blur. This mimics the glow of a monitor rather than a physical drop shadow.
*   **The "Ghost Border":** If accessibility requires a stroke, use `outline_variant` (#3F4851) at **20% opacity**. It should be felt, not seen.

---

## 5. Components

### Buttons
*   **Primary:** Gradient fill (`primary` to `primary_container`), `on_primary` text, `xl` roundedness (0.75rem).
*   **Secondary:** No fill. `outline_variant` ghost border (20% opacity). `on_surface` text.
*   **Interaction:** On hover, primary buttons should "glow" using a `4px` spread of `primary` at 30% opacity.

### Task Cards (The Core Component)
*   **Structure:** No borders. Use `surface-container-low`. 
*   **Spacing:** `1.5rem` padding.
*   **Visual Logic:** Forbid the use of divider lines between tasks. Use a `1rem` vertical gap (Spacing Scale) to let the "ink" breathe.

### Interactive Inputs
*   **Input Fields:** Use `surface_container_lowest` for the field background. Upon focus, change the background to `surface_container_high` and add a `2px` left-accent border of `secondary` (#90CDFF).
*   **Checkboxes:** When checked, the box should morph into a `primary` circle with an `on_primary` checkmark, signaling a completed "event" in the learning process.

### Learning Chips
*   **Status Tags:** Small, `label-sm` caps. Backgrounds should use "Fixed" tokens (e.g., `secondary_fixed` for "In Progress").

---

## 6. Do’s and Don’ts

### Do
*   **Do** use asymmetrical padding (e.g., more padding at the top of a section than the bottom) to create an editorial flow.
*   **Do** lean into the "Developer" feel by using `Inter` for all numeric data and timestamps.
*   **Do** use `secondary` (Blue) for learning-related feedback and `primary` (Amber) for task-related actions.

### Don’t
*   **Don’t** use pure black (#000000) or pure white (#FFFFFF). Use the `surface` and `on_surface` tokens to maintain the premium tonal range.
*   **Don’t** use 1px solid dividers to separate tasks. It creates visual noise. Use whitespace.
*   **Don’t** use standard "drop shadows." If an element needs to float, use tonal contrast or a wide, tinted ambient glow.