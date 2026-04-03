## Abstraction
# from abc import ABC, abstractmethod


# class Shape(ABC):
#     @abstractmethod
#     def area(self):
#         pass
#
#     @abstractmethod
#     def perimeter(self) -> None:
#         pass


## Inheritance
# class Shape:
#     def __init__(self, length, width):
#         self.length = length
#         self.width = width
#
#
# class Rectangle(Shape):
#     def area(self):
#         return self.length * self.width
#
#
# r = Rectangle(7, 4)


## Polymorphism


class Shape:
    def area(self):

        pass


class Rectangle(Shape):
    def __init__(self, length, width) -> None:
        self.length = length
        self.width = width

    def area(self):
        return self.length * self.width


class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        return 3.14 * (self.radius**2)


# creating objects of different classes
rectangle = Rectangle(7, 4)
circle = Circle(4)

print(rectangle.area())  # should return 28
print(circle.area())  # should return 50.24
