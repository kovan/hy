# poetry-hy-plugin

A [Poetry](https://python-poetry.org/) plugin that adds a `new-hy` command to scaffold [Hy](https://hylang.org/) projects.

## Installation

```bash
poetry self add poetry-hy-plugin
```

## Usage

```bash
poetry new-hy my-project
cd my-project
poetry install
```

## Getting Started

```bash
cd my-project
poetry install
poetry run my-project
```

## Generated Structure

```
my-project/
├── pyproject.toml
├── README.md
├── LICENSE
├── my_project/
│   ├── __init__.py
│   └── main.hy
└── tests/
    ├── conftest.py
    └── test_main.hy
```
