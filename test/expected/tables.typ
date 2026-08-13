#set document(title: [Table export], author: ("Test Author"))

#outline()

= Header plus body rule

#table(
  columns: 3,
  align: (left, right, right),
  stroke: none,
  table.header(
    [Item], [Qty], [Price],
    table.hline(),
  ),
  [Apple], [3], [1.20],
  [Pear], [1], [0.80],
  table.hline(),
  [Total], [4], [2.00],
)


= Fully ruled, top border first

#table(
  columns: 2,
  align: (left, right),
  stroke: none,
  table.header(
    table.hline(),
    [Item], [Qty],
    table.hline(),
  ),
  [Apple], [3],
  table.hline(),
)


= No rules at all

#table(
  columns: 2,
  align: (left, right),
  stroke: none,
  [Apple], [3],
  [Pear], [1],
)


= Rule below the second row

Org treats everything before the first rule as the header, the same way
`ox-latex` and `ox-html` do, so both rows above the rule end up in
`table.header`.

#table(
  columns: 2,
  align: (left, right),
  stroke: none,
  table.header(
    [Apple], [3],
    [Pear], [1],
    table.hline(),
  ),
  [Total], [4],
)


= Consecutive rules collapse

#table(
  columns: 2,
  align: (left, right),
  stroke: none,
  table.header(
    [Item], [Qty],
    table.hline(),
  ),
  [Apple], [3],
)


= Caption and name become a figure

#figure(
  table(
    columns: 2,
    align: (left, right),
    stroke: none,
    table.header(
      [Item], [Qty],
      table.hline(),
    ),
    [Apple], [3],
    [Pear], [1],
  ),
  caption: [Quarterly fruit sales],
) <tbl-fruit>

See @tbl-fruit.


= Caption with markup

#figure(
  table(
    columns: 2,
    align: (left, right),
    stroke: none,
    table.header(
      [Item], [Qty],
      table.hline(),
    ),
    [Apple], [3],
  ),
  caption: [Sales for _Q1_, *revised*],
)


= Name alone is still wrapped, so it can be referenced

#figure(
  table(
    columns: 2,
    align: (left, right),
    stroke: none,
    table.header(
      [Item], [Qty],
      table.hline(),
    ),
    [Apple], [3],
  ),
) <tbl-bare>

Cross-reference: @tbl-bare.


= ATTR#sub[TYPST] overrides the defaults

#table(
  columns: 2,
  align: (left, right),
  stroke: 1pt,
  column-gutter: 1em,
  table.header(
    [Item], [Qty],
    table.hline(),
  ),
  [Apple], [3],
)


= Alignment cookies

#table(
  columns: 3,
  align: (right, center, left),
  stroke: none,
  table.header(
    [right], [ctr], [left],
    table.hline(),
  ),
  [a], [b], [c],
)
