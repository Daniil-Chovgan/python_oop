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
*Инкапсуляция* -- данные и методы которые существуют внутри класса, отделенные от интерфейса, объединенные в единое целое.#footnote[определение из лекции по ООП от 10.10.26]<oop>
]

#calepin.elements.card[
*Инкапсуляция* -- Один объект будет содержать как свои данные, так и поведения, и сможет скрыть то, что ему потребуется, от других объектов.#footnote[Объектно-ориентированное мышление -- Мэтт Вайсфельд]
]

*Уровни:*
  - `private` - доступны исключительно классу
  - `protect` - доступны наследникам, но не доступно извне
  - `public` - доступны извне

== Сокрытие
#calepin.elements.card[
*Сокрытие* -- защищенные данные от изменений извне.@oop
]

При проектировании языка python исходили из концепции: "все мы взрослые люди".
Поэтому в python нет классических `public`, `protect` и `private` полей.

Однако вместо этого есть соглашение о наименовании доступов. И #link("https://peps.python.org/pep-0008/")[PEP 8] они описываются так:

- `_single_leading_underscore`: слабый индикатор "внутреннего использования". Например, `from M import *` не импортирует объекты, имена которых начинаются с подчеркивания.
- `single_trailing_underscore_`: используется по соглашению во избежание конфликтов с ключевым словом Python, например:
- `tkinter.Toplevel(master, class_='ClassName')`
- `__double_leading_underscore`: при именовании атрибута класса вызывает искажение имени (внутри класса FooBar `__boo` становится `_FooBar__boo`; см. ниже).
- `__double_leading_and_trailing_underscore__`: «магические» объекты или атрибуты, которые находятся в управляемых пользователем пространствах имен. Например, `__init__`, `__import__` или `__file__`. Никогда не придумывайте такие имена; используйте их только в соответствии с документацией.
