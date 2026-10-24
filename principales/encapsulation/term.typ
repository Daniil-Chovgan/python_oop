#import "/.calepin/calepin.typ" as calepin

#set document(title: [Инкапсуляция])
#metadata((title: "Инкапсуляция", translation_key: "encapsulation")) <website-metadata>

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
*Инкапсуляция* -- данные и методы которые существуют внутри класса, отделенные от интерфейса, объединенные в единое целое.#footnote[определение из лекции по ООП от 10.10.26]
]

#calepin.elements.card[
*Инкапсуляция* -- Один объект будет содержать как свои данные, так и поведения, и сможет скрыть то, что ему потребуется, от других объектов.#footnote[Объектно-ориентированное мышление -- Мэтт Вайсфельд] <oop>
]

#calepin.elements.card[
*Сокрытие* -- защищенные данные от изменений извне.#footnote[определение из лекции по ООП от 10.10.26]
]

*Уровни:*
  - `private` - доступны исключительно классу
  - `protect` - доступны наследникам, но не доступно извне
  - `public` - доступны извне
