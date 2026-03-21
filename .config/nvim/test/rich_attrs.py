# pyright: ignore[unresolved-reference]
import attrs


@attrs.define
class Point3D:
    x: float
    y: float
    z: float = 0


@attrs.define
class Triangle:
    point1: Point3D
    point2: Point3D
    point3: Point3D


@attrs.define
class Model:
    name: str
    triangles: list[Triangle] = attrs.Factory(list)


if __name__ == "__main__":
    model = Model(
        name="Alien#1",
        triangles=[
            Triangle(
                Point3D(x=20, y=50),
                Point3D(x=50, y=15, z=-45.34),
                Point3D(3.1426, 83.2323, -16),
            )
        ],
    )

    from rich.console import Console
    from rich.pretty import Pretty
    from rich.table import Table, Column
    from rich.text import Text

    console = Console()

    table = Table(
        "attrs *with* Rich", Column(Text.from_markup("attrs *without* Rich"))
    )

    table.add_row(Pretty(model), repr(model))
    console.print(table)
