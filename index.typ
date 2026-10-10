#import "/.calepin/calepin.typ" as calepin
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *

#set document(title: [Объектно-ориентированное программирование в python])
#metadata((title: "Home", translation_key: "home")) <website-metadata>

#calepin.setup(
  echo: true,
  eval: true,
  results: "verbatim",
  fenced-chunks: true,
)


#let target = sys.inputs.at("calepin-target", default: "paged")

#show: body => {
  if target == "html" {
    body
  } else {
    // set page(columns: 2)
    show: codly-init
    show: calepin.document
    codly(languages: codly-languages)
    // Hand the code to codly, and drop Calepin's own box from around it.
    show <calepin-input>: it => it.body
    // Give codly the same palette Calepin paints executed chunks with, so the
    // plain fence below matches the chunk above it.
    set raw(theme: "/.calepin/syntax.tmTheme")


    body
  }
}



#calepin.setup(echo: true)



// #if target == "html" {
//   html.elem("img", "", attrs: (
//     class: "calepin-float-right calepin-scaffold-portrait",
//     src: "assets/portrait.jpg",
//     alt: "Portrait photograph",
//     width: "1280",
//     height: "1920",
//     loading: "lazy",
//     decoding: "async",
//   ))
// } else {
//   place(
//     top + right,
//     float: true,
//     clearance: 1em,
//     image("/assets/portrait.jpg", width: 32%),
//   )
// }


#title()

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


def func(num):
    print(f"Новый метод №{num}")

b.c = func
b.c(1)
```

При этом вызвать новый метод будет именно методом конкретного объекта:
```python
#| eval: false
a.b
a.c(2)
```
Такой код вызывает ошибку.

Такой подход позволяет реализовывать активную интроспекцию и рефлексию, меняя, добавляя и удаляя поля в рантайме.




== Наследование

По большому сче2ту принцип наследования можно свести к дополнительному способу доступа к атрибутам.

В python наследование организуется через добавление класса родителя в `__mro__` и `__bases__`\
Если кратко, то `__bases__` хранит в себе классы своих родителей, а `__mro__` линейный список всех своих предков.

К примеру:

```python
class A: ...
class B: ...
class C(A, B): ...

C.__bases__
C.__mro__
```

А так же в python существует метод , благодаря которому можно добавить в качестве базового класса объект.\
Так же в python в качестве предка можно использовать любой объект с помощью метода `__mro_entries__`. Он принимает `tuple` из всех базовых классов наследника и возвращает `tuple` из классов (то есть экземпляров `type`)

К примеру отнаследуемся от функции:
```python
def my_func():
    print('called')
my_func.__mro_entries__ = lambda bases: (str,)

class MyStr(my_func): ...

print(MyStr.__mro__)
print(MyStr('abc'))
```

И нам на самом деле ничего не мешает изменить, дополнить, удалить предка наследуемого класса

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
С помощью конструктора type мы можем создать MyClass во время выполнения:
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
//
