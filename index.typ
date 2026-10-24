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

== Класс
Python сильно более объектно ориентирован, чем многие языки. Почти все что вы встретите в python будет объектом.\
Функции, числа, классы, модули - это все объекты.

По сути тип данных в python - это класс объекта. Так что для получения класса объекта есть `type`

```python
type(1)
type([1, "2", (3,)])
class A: ...
type(A())
```
Но в python как говорилось раньше практически все - это объект
К примеру:
```python
type(A)
type(type)
def func(): ...
type(func)
type(type(func))
```

Как мы знаем у классов есть атрибуты и методы.


// Так же python в классической реализации CPython без надстроек по типу mypy, python имеет динамическую подноготную


На уровне реализации языка внутри каждый объект - это struct в Си, которая содержит:
- Счетчик ссылок: `ob_refcnt`
- Указатель на тип: `ob_type`

И выглядит примерно так:
```c
#| eval: false
typedef struct _object {
    _PyObject_HEAD_EXTRA
    Py_ssize_t ob_refcnt;
    PyTypeObject *ob_type;
} PyObject;
```

Тут `_PyObject_HEAD_EXTRA` - макрос, который добавляет указатели на предыдущий и следующий объект в памяти. Это позволяет сборщику мусора ходить по двухсвязному списку всех активных объектов и удалять их в случае необходимости

Для объектов переменной длины так же имеются поле `ob_size`. Такие объекты называются `PyVarObject`.

```c
#| eval: false
typedef struct {
    PyObject ob_base;
    Py_ssize_t ob_size;
} PyVarObject;
```

== Класс в python
Класс создается с помощью ключевого слова `class`:
```python
class Test:
    pass
```

Хотя он и кажется пустым, тем не менее он имеет целую охапку полей и методов, которые python создает автоматически. Их можно увидеть с помощью функции `dir()` и `var()`:


```python
dir(Test)
```

```python
vars(Test)
```

Чтобы создать объект класса достаточно вызвать его с синтаксисом похожим на функцию
```python
a = Test()
a
```

На самом деле это и является неявно вызываемыми функциями, которая вызывается каждый раз при создании объекта. А конкретно метод `__new__` класса Test (выделяет память и создает объект данного класса). А так же метод `__init__()` объекта, который дает логику внутрь объекта (к примеру заполняет его поля). Так что семантически такой вариант будет аналогичным:

```python
a = Test.__new__(Test)

if isinstance(a, Test):
    a.__init__()

a
```

Так что если при написании класса мы определим метод `__init__`, тогда объект класса будет иметь соответсвующую логику::
```python
class Test:
    def __init__(self):
        print("Hello, world!")
        self.a = 123
```

```python
a = Test()
a.a
```

Аналогично:

```python
b = Test.__new__(Test)

if isinstance(a, Test):
    b.__init__()

b.a
```

Так же мы можем в рантайме изменять, добавлять и удалять атрибуты и методы
```python
b.b = "Новый аттрибут"
b.b
```

```python
def func(num):
    print(f"Новый метод №{num}")

b.c = func
b.c(1)
```

При этом вызвать новый метод будет именно методом конкретного объекта:
```python
#| error: true
a.b
a.c(2)
```


Такой подход позволяет реализовывать активную интроспекцию и рефлексию, меняя, добавляя и удаляя поля в рантайме.


== Инкапсуляция

=== Сокрытие
При проектировании языка python исходили из концепции: "все мы взрослые люди".
Поэтому в python нет классических `public`, `protect` и `private` полей.

Однако вместо этого есть соглашение о наименовании доступов. И PEP 8 они описываются так:

- `_single_leading_underscore`: слабый индикатор "внутреннего использования". Например, `from M import *` не импортирует объекты, имена которых начинаются с подчеркивания.
- `single_trailing_underscore_`: используется по соглашению во избежание конфликтов с ключевым словом Python, например:
- `tkinter.Toplevel(master, class_='ClassName')`
- `__double_leading_underscore`: при именовании атрибута класса вызывает искажение имени (внутри класса FooBar `__boo` становится `_FooBar__boo`; см. ниже).
- `__double_leading_and_trailing_underscore__`: «магические» объекты или атрибуты, которые находятся в управляемых пользователем пространствах имен. Например, `__init__`, `__import__` или `__file__`. Никогда не придумывайте такие имена; используйте их только в соответствии с документацией.

== Полиморфизм
=== Перегрузка
В python в отличии от `C++` нет классической перегрузки. \
В том числе потому что часть сути

```python
def func(a, b):
    return a+b

func(1,2)
func("1", "2")
```
=== Утиная типизация
Основная идея утиной типизации - это принцип "если что-то выглядит как утка, крякает утка, то это утка" и python переполнен примерами применения


== Метаклассы

По сути метаклассы - это классы объектами которами являются другие классы.\
Раньше мы применяли `type` как функцию, которая принимает объект и возвращает класс объекта.\
Но на самом деле это класс, который при передаче одного аргумента возвращает класс, к которому относится объект

```python
class MySuperClass: ...
class MyMixin: ...

class MyClass(MySuperClass, MyMixin):
    x = 42
    def x2(self):
        return self.x * 2

MyClass()
```
С помощью конструктора `type` мы можем создать `MyClass` во время выполнения:
```python
MyClass = type('MyClass',
        (MySuperClass, MyMixin),
        {'x': 42, 'x2': lambda self: self.x * 2},
    )

MyClass()
```

// TODO: Рассказать про алгоритм с точки зрения математики.
// TODO: Рассказать об особенностях выделения, освобождения и зачистки памяти спецефически для объектов в python
// TODO: `__dict__` и `__slots__`


// #| results-location: chunk
