# hy-templates

![CI](https://github.com/kovan/hy/actions/workflows/ci.yml/badge.svg)

Project templates for bootstrapping [Hy](https://hylang.org/) (a Lisp embedded in Python) projects.

## Templates

| Tool | Directory | Setup | Usage |
|------|-----------|-------|-------|
| **Cookiecutter** | [cookiecutter-hy/](cookiecutter-hy/) | `pip install cookiecutter` | `cookiecutter gh:kovan/cookiecutter-hy` |
| **PDM** | *(uses cookiecutter)* | `pip install cookiecutter` | `pdm init --cookiecutter gh:kovan/cookiecutter-hy` |
| **Copier** | [copier-hy/](copier-hy/) | `pip install copier` | `copier copy gh:kovan/copier-hy my-project` |
| **Poetry** | [poetry-hy/](poetry-hy/) | `poetry self add poetry-hy-plugin` | `poetry new-hy my-project` |
| **Hatch** | [hatch-hy/](hatch-hy/) | `pipx inject hatch hatch-hy` | `hatch new my-project` |

The plugins are also on PyPI:
[pytest-hy](https://pypi.org/project/pytest-hy/) |
[poetry-hy-plugin](https://pypi.org/project/poetry-hy-plugin/) |
[hatch-hy](https://pypi.org/project/hatch-hy/)

## Generated Structure

All templates produce the same project:

```
my-project/
├── pyproject.toml          # hy dependency, *.hy package-data
├── README.md
├── LICENSE
├── my_project/
│   ├── __init__.py
│   └── main.hy
└── tests/
    └── test_main.hy
```

## Why?

Starting a Hy project requires non-obvious boilerplate:
- `*.hy` in `package-data` so `.hy` files get included in wheels
- `hy` as both a build and runtime dependency
- `pytest-hy` for `.hy` test discovery

These templates handle all of that.
