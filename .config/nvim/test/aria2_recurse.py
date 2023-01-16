"""
First version is the Dotted format -> Pycharm's version
Second version is the Pytest format
defaut value (elsewhere in file):
apps.foo.bar
"""

# apps.foo.bar.function_2
# def func_1():
#     pass

# apps.foo.bar.func2
# async def func_2():
#     pass

# apps.foo.bar.function_decorator
def function_decorator():

    # apps.foo.bar.function_decorator.inner_func
    def inner_function():
        pass


# apps.foo.bar.Baz
class Baz:

    # apps.foo.bar.Baz.Meta
    class Meta:
        pass

    # apps.foo.bar.Baz.method_1
    def method_1(self):
        pass
