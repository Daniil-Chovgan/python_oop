#import "/.calepin/calepin.typ" as calepin

#set document(title: [Абстракция])
#metadata((title: "Абстракция", translation_key: "abstraction")) <website-metadata>

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
*Абстракция* -- парадигма, позволяющая на этапе проектирования ответить на вопрос: "что должен делать объект".#footnote[определение из лекции по ООП от 10.10.26]
]

#calepin.elements.card[
*Абстракция* — это выделение главных, существенных характеристик объекта и его внешнего интерфейса с сокрытием внутренних деталей реализации. Она позволяет сформулировать единый "контракт" (набор методов), которому обязаны следовать все его конкретные подклассы. #footnote[Объектно-ориентированное мышление -- Мэтт Вайсфельд]
]

В Python абстракция реализуется с помощью встроенного модуля `ABC` (Abstract Base Classes):

Особенности:
+ *Создание абстрактного класса:* Класс наследуется от `abc.ABC`.
+ *Абстрактные методы:* Методы интерфейса, у которых нет готовой реализации, помечаются декоратором `@abc.abstractmethod`.
+ *Защита от инстанцирования:* Создать экземпляр абстрактного класса напрямую нельзя. Если в подклассе не реализован хотя бы один абстрактный метод, при попытке создать его экземпляр Python выбросит исключение `TypeError`.

```python
from abc import ABC, abstractmethod
import math

class Shape(ABC):

    @abstractmethod
    def area(self):
        """Метод для вычисления площади"""
        pass

    @abstractmethod
    def perimeter(self):
        """Метод для вычисления периметра"""
        pass


class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

    def perimeter(self):
        return 2 * (self.width + self.height)


class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        return math.pi * self.radius ** 2

    def perimeter(self):
        return 2 * math.pi * self.radius
```

```python
rect = Rectangle(5, 10)
circle = Circle(7)
```

Площадь прямоугольника:
```python
rect.area()
```

Периметр прямоугольника:
```python
rect.perimeter()
```

Площадь круга:
```python
circle.area()
```

Вот что будет, если попробовать создать экземпляр абстрактного класса:
```python
#| error: true
shape = Shape()
```
