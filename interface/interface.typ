#import "/.calepin/calepin.typ" as calepin

#set document(title: [Интерфейс])
#metadata((title: "Интерфейс", translation_key: "interface")) <website-metadata>

#calepin.setup(
  echo: true,
  eval: true,
  results: "verbatim",
  fenced-chunks: true,
)

#let target = sys.inputs.at("calepin-target", default: "paged")

#show: body => {
  if target == "html" {
    show <calepin-input>: it => it.body
    body
  } else {
    import "@preview/codly:1.3.0": *
    import "@preview/codly-languages:0.1.10": *
    show: codly-init
    show: calepin.document
    codly(languages: codly-languages)
    codly(number-format: none)
    show <calepin-input>: it => it.body
    set raw(theme: "/.calepin/syntax.tmTheme")
    body
  }
}

#calepin.setup(echo: true)

#title()


#calepin.elements.card[
*Интерфейс* -- набор данных и методов, доступных извне.#footnote[определение из лекции по ООП от 10.10.26]
]
