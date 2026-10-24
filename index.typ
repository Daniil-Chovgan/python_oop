#import "@preview/cades:0.3.1": qr-code
#import "/.calepin/calepin.typ" as calepin

#set document(title: [Объектно-ориентированное программирование в python])
#metadata((title: "Вступление", translation_key: "start")) <website-metadata>

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

Этот сайт посвящен особенностям ООП в python. Для открытия у себя на устройстве можете отсканировать qr:
#figure(
  qr-code(
    "https://daniil-chovgan.github.io/python_oop/",
    width: 5cm
  )
)

== Что позволяет ООП
+ Позволяет переиспользовать код
+ Позволяет готовить абстракции, заготовки
+ Позволяет приблизить программную модель к модели реального мира, что существенно упрощает её восприятие
+ Упрощает сопровождение больших систем, т.к. изолируем изменения в рамках одного компонента


// TODO: Рассказать про алгоритм с точки зрения математики.
// TODO: Рассказать об особенностях выделения, освобождения и зачистки памяти спецефически для объектов в python
// TODO: `__dict__` и `__slots__`


// #| results-location: chunk
