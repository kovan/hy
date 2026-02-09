# hy-templates

Project templates for bootstrapping [Hy](https://hylang.org/) (a Lisp embedded in Python) projects.

## Templates

| Tool | Directory | Install | Usage |
|------|-----------|---------|-------|
| **Cookiecutter** | [cookiecutter/](cookiecutter/) | `pip install cookiecutter` | `cookiecutter gh:kovan/hy --directory cookiecutter` |
| **PDM** | *(uses cookiecutter)* | `pip install cookiecutter` | `pdm init --cookiecutter gh:kovan/hy --directory cookiecutter` |
| **Poetry** | [poetry/](poetry/) | `poetry self add poetry-hy-plugin` | `poetry new-hy my-project` |
| **Hatch** | [hatch/](hatch/) | `pipx inject hatch hatch-hy` | `hatch new my-project` |

The Poetry and Hatch plugins are also on PyPI:
[poetry-hy-plugin](https://pypi.org/project/poetry-hy-plugin/) |
[hatch-hy](https://pypi.org/project/hatch-hy/)

## Generated Structure

All templates produce the same project:

```
my-project/
├── pyproject.toml          # hy dependency, *.hy package-data
├── README.md
├── LICENSE
├── conftest.py             # pytest discovery for .hy files
├── src/
│   └── my_project/
│       ├── __init__.hy
│       └── main.hy
└── tests/
    └── test_main.hy
```

## Why?

Starting a Hy project requires non-obvious boilerplate:
- `*.hy` in `package-data` so `.hy` files get included in wheels
- `hy` as both a build and runtime dependency
- `conftest.py` with a `pytest_collect_file` hook for `.hy` test discovery

These templates handle all of that.
