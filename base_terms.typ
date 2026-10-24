#import "/.calepin/calepin.typ" as calepin

#set document(title: [Основные понятия])
#metadata((title: "Основные понятия", translation_key: "base_terms")) <website-metadata>

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
  *Класс* -- шаблон описания структуры данных и поведения экземпляров
]

#calepin.elements.card[
  *Объект (экземпляр)* -- элемент, созданный по шаблону класса
]

#calepin.elements.card[
  *Атрибут* -- данные, хранящиеся в объекте или классе
]

#calepin.elements.card[
  *Метод* -- функция, описанная внутри класса (объекта)
]

#calepin.elements.card[
  *Сообщение* -- вызов одного метода другим методом
]
