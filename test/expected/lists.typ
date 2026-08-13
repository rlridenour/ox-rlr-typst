#set document(title: [List export], author: ("Test Author"))

#outline()

Each list gets its own heading on purpose: Org merges two lists
separated by a single blank line into one list, and the merged list
takes its type from the first item, which would quietly change what is
being tested here.


= Unordered, with nesting

- first
- second
  - nested
    - deeper
- third


= Ordered

+ one
+ two
  + two point one
+ three


= Ordered with a different bullet

+ alpha
+ beta


= Checkboxes

- [ ] unchecked
- [X] checked
- [-] partial


= Description list

/ term: its definition
/ another term: a definition with _markup_ in it


= Item holding several paragraphs

- first paragraph of the item
  
  second paragraph of the same item
- a following item


= Item holding a nested block

- an item
  
  #quote(block: true)[
  quoted inside a list item]
- another item


= Markup inside items

- *bold*, _italic_, `code`, and a #link("https://typst.app")[link]


= Wrapped in a Typst function

#let standard-form(body) = block(inset: 1em, body)

#standard-form[
+ First premise
+ Second premise
+ Third premise
+ Conclusion
]

An unrecognized attribute is ignored rather than emitted.

- plain after all
