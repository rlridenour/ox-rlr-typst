#set document(title: [Citation export], author: ("Test Author"))

#outline()

= Styles

Plain #cite(<knuth1984>, form: "normal") uses Typst's normal form.

Prose #cite(<knuth1984>, form: "prose") renders the author inline.

Author only #cite(<knuth1984>, form: "author").

Year only #cite(<knuth1984>, form: "year").

Full entry #cite(<lamport1994>, form: "full").

Uncited but listed #cite(<lamport1994>, form: none).


= Locators and affixes

A locator becomes a supplement #cite(<knuth1984>, supplement: "pp. 27-29", form: "normal").

Several keys in one citation #cite(<knuth1984>, form: "normal")#cite(<lamport1994>, form: "normal").

A citation carrying prefix and suffix text #cite(<knuth1984>, supplement: "see  for more", form: "normal").


= Bibliography

The exporter has no `#+PRINT_BIBLIOGRAPHY` handling yet — the keyword
below exports to nothing — so the bibliography is emitted by hand with
a `#+TYPST:` passthrough, which is also what makes `#cite` calls
resolve when the output is compiled.

#bibliography("refs.bib")
