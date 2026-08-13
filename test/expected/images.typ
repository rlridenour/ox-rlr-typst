#set document(title: [Image export], author: ("Test Author"))

#outline()

= Caption and name

#figure(
  image("img.png"),
  caption: [A small square],
) <fig-square>

See @fig-square and #link(<fig-bare>)[this one].


= Name only, no caption

#figure(
  image("img.png"),
) <fig-bare>


= Caption only, no name

#figure(
  image("img.png"),
  caption: [Unnamed but captioned],
)


= Plain image, neither

#image("img.png")


= Inline image inside a sentence

Text before #image("img.png") text after.
