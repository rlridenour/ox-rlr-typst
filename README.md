# ox-rlr-typst

An Org export back-end that turns an Org buffer into standard
[Typst](https://typst.app) markup (`.typ`). Org has no built-in Typst
exporter, so this fills that gap the same way `ox-md.el` or
`ox-latex.el` do for their targets.

## Usage

Load the file and export as you would with any other Org back-end:

```elisp
(require 'ox-rlr-typst)
```

- `M-x org-rlr-typst-export-to-typst` — export the current buffer to a
  sibling `.typ` file.
- `M-x org-rlr-typst-export-as-typst` — export to a temporary buffer.
- From the export dispatcher (`C-c C-e`), it's listed under `y` ("Export
  to Typst").
- `org-rlr-typst-publish-to-typst` works as a `:publishing-function` in
  `org-publish-project-alist`.

## What gets translated

- **Headings** map 1:1 onto Typst heading depth (`*` → `=`, `**` → `==`,
  ...), offset by `org-rlr-typst-toplevel-hlevel` if you need to splice
  the output into a larger document.
- **Emphasis**: bold/italic use Typst's own shorthand (`*bold*`,
  `_italic_`); underline and strike-through become `#underline[...]`
  and `#strike[...]`.
- **Code/verbatim** become backtick-fenced Typst raw spans, sized to
  the shortest fence that safely encloses the content (with a guard
  space added when the fence reaches 3 backticks, since Typst would
  otherwise misread the leading word as a language tag).
- **Source/example blocks** become fenced raw blocks (```` ```lang ````
  for source blocks, using the Org `#+begin_src` language).
- **Lists** (unordered, ordered, checkbox, description) map onto
  Typst's `-`, `+`, `[ ]`/`[X]`, and `/ term: ...` syntax respectively.
- **Tables** become native `#table(...)` calls, with the leading row
  group wrapped in `table.header(...)` when the Org table has one, and
  per-column alignment carried over from Org's alignment cookies.
- **Links**: external URLs become `#link("url")[desc]`; internal links
  to a heading (via `CUSTOM_ID`, `ID`, or fuzzy `[[title]]` links)
  become `@label` or `#link(<label>)[desc]`; image links become
  `#image(...)` or, with a caption, `#figure(image(...), caption: [...])`.
- **Footnotes** are inlined at their first reference as
  `#footnote[...] <fn-LABEL>`; later references to the same *named*
  footnote (`[fn:mylabel]`) reuse the label as `#footnote(<fn-LABEL>)`
  instead of repeating the text. Anonymous footnotes (`[fn::...]`)
  can't be referenced twice in Org, so this covers every repeatable
  case.
- **Math** — `$...$`, `$$...$$`, `\(...\)`, `\[...\]`, and LaTeX
  environments (`\begin{...}...\end{...}`) — is rendered through the
  [mitex](https://typst.app/universe/package/mitex) package via
  `#mi(...)` (inline) or `#mitex(...)` (block), so ordinary LaTeX math
  syntax keeps working unchanged. The `#import` line for mitex is only
  emitted when the document actually contains math.
- **`#+begin_export typst ... #+end_export`** blocks and the
  **`#+TYPST: ...`** keyword pass through verbatim — the same
  convention already used by `rlr-org-standard-form.el`.
- **Any other special block**, `#+begin_NAME ... #+end_NAME`, becomes
  `#NAME[...]`, so you can invoke your own Typst functions directly
  from Org (e.g. `#+begin_note ... #+end_note` → `#note[...]`).
- **`#+TOC: headlines`** becomes `#outline()`.

Anything not explicitly handled above falls back to the built-in
`ascii` back-end's rendering (this exporter derives from it), which is
a reasonably harmless plain-text fallback for exotic constructs like
inline tasks, clocks, or planning lines.

## Dependencies

The generated `.typ` file only needs the `mitex` package, and only
when the source document contains LaTeX math — Typst fetches it
automatically from the Typst Universe registry the first time you
compile, no local package install required.

## Known limitations

- `table.el`-style tables (drawn with `table.el`, not the native Org
  table syntax) aren't translated; they fall back to a raw code block.
- Column widths, cell colspan/rowspan, and other advanced table
  attributes aren't carried over.
- The document template only emits `#set document(title:, author:)`
  metadata (plus a commented-out date) — it doesn't assume any
  particular Typst document class or template package, since that
  varies per project. Wrap the exported body in your own template's
  `#show` rule as needed.
