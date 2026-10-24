#import "/.calepin/calepin.typ" as calepin

#set document(title: [Полиморфизм])
#metadata((title: "Полиморфизм", translation_key: "polymorphism")) <website-metadata>

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
Полиморфизм -- способность объекта по одному и тому же интерфейсу отвечать по-разному, в зависимости от реализации.#footnote[определение из лекции по ООП от 10.10.26]
]
#calepin.elements.card[
Полиморфизм -- Означает, что схожие объекты способны по-разному отвечать на одно и то же сообщение.#footnote[Объектно-ориентированное мышление -- Мэтт Вайсфельд] <oop>
]

В отличие от классических статически типизированных языков, в Python полиморфизм гораздо шире и проникает на все уровни языка — от классического наследования до динамических протоколов

== Классический полиморфизм через наследование и переопределение методов

В традиционном ООП родительский класс определяет общий интерфейс (например, метод `draw()`), а дочерние классы переопределяют этот метод своей конкретной реализацией

```python
class Shape:
    def draw(self) -> None:
        pass

class Circle(Shape):
    def draw(self) -> None:
        print("Рисуем круг")

class Rectangle(Shape):
    def draw(self) -> None:
        print("Рисуем прямоугольник")

```

Единый интерфейс, но разное поведение объектов `shapes`:
```python
shapes: list[Shape] = [Circle(), Rectangle()]
for shape in shapes:
    shape.draw()
```

== Утиная типизация
В Python наследование от общего базового класса вовсе не обязательно. Главный принцип динамической утиной типизации гласит: если объект поддерживает необходимый метод или операцию, не имеет значения, к какому классу он принадлежит.

```python
class Document:
    def render(self) -> None:
        print("Рендеринг документа...")

class Image:
    def render(self) -> None:
        print("Отображение картинки...")

def display(printable_object) -> None:
    printable_object.render()
```

И такие вызовы работают без общего родительского класса:
```python
display(Document())
display(Image())
```
Среда выполнения Python проверяет наличие и поддержку операций объектом непосредственно в момент выполнения

== Статическая утиная типизация

Чтобы сохранить гибкость утиной типизации и при этом дать возможность статическим анализаторам (таким как Mypy) проверять типы до запуска программы, в Python используются протоколы из модуля `typing`

```python
from typing import Protocol

class Renderable(Protocol):
    def render(self) -> None: ...

class WebPage:
    def render(self) -> None:
        print("Отображение веб-страницы")

def render_element(element: Renderable) -> None:
    element.render()

render_element(WebPage())
```

Классу не требуется явно объявлять наследование от протокола — достаточно просто реализовать совпадающие методы

== Гусиная типизация

Когда необходимо явно зафиксировать контракт интерфейса во время выполнения, используется проверка принадлежности к абстрактным базовым классам (ABC) с помощью

```python
from collections.abc import Iterable

def process_items(items: Iterable) -> None:
    if isinstance(items, Iterable):
        for item in items:
            print(item)
```
Проверка через ABC разрешает полиморфизм для любых итерируемых объектов

Это позволяет проверять соответствие интерфейсу, сохраняя полиморфизм для любых совместимых классов или зарегистрированных виртуальных подклассов

== Одиночная диспетчеризация

Полиморфизм на уровне отдельных функций позволяет выполнять разный код в зависимости от типа переданного аргумента во время выполнения

```python
from functools import singledispatch

@singledispatch
def process(data) -> None:
    print(f"Базовая обработка: {data}")

@process.register(int)
def _(data: int) -> None:
    print(f"Числовая обработка: {data * 2}")

@process.register(list)
def _(data: list) -> None:
    print(f"Список из {len(data)} элементов")

process("текст")
process(10)
process([23, 24])
```

Такой подход облегчает модульное расширение программы без раздувания цепочек `if/elif` или изменения существующих классов
