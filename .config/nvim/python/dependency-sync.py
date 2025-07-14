import tomllib
from pathlib import Path


def sync():
    pyproject = tomllib.loads(Path("pyproject.toml").read_text())
    dependencies = pyproject["project"]["dependencies"]
    with open("python/requirements.txt", "w") as req:
        for dep in dependencies:
            req.write(f"{dep}\n")


if __name__ == "__main__":
    sync()
