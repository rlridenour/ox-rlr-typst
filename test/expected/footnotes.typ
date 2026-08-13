#set document(title: [Footnote export], author: ("Test Author"))

#outline()

The definitions live under the "Footnotes" heading at the end, which
Org treats as \`org-footnote-section' and drops from the export, so it
should not appear in the expected output.


= Named, anonymous, and repeated

A named footnote#footnote[The first definition.] <fn-one>, an anonymous one#footnote[inline text, defined in
place], and a second reference to the first#footnote(<fn-one>) — the repeat reuses
the label instead of duplicating the definition.


= A second named footnote

Distinct labels get distinct definitions#footnote[The second definition.] <fn-two>.


= Markup inside a definition

Definitions are transcoded like any other content#footnote[Contains *bold*, _italic_, and a #link("https://typst.app")[link].] <fn-markup>.


= References from other constructs

- a list item with a footnote#footnote[Referenced from inside a list.] <fn-inlist>
- a plain item

#table(
  columns: 2,
  align: (left, left),
  stroke: none,
  [a table cell#footnote[Referenced from inside a table.] <fn-intable>], [second],
)
