# hatch-hy

A [Hatch](https://hatch.pypa.io/) template plugin for [Hy](https://hylang.org/) projects.

> **Note:** This plugin uses Hatch's undocumented template plugin API. It has been tested with Hatch 1.x but the API may change.

## Installation

```bash
pipx inject hatch hatch-hy
```

## Usage

```bash
hatch new my-hy-project
cd my-hy-project
pip install -e .
my-hy-project
```

## Generated Structure

```
my-hy-project/
├── pyproject.toml
├── README.md
├── LICENSE
├── my_hy_project/
│   ├── __init__.py
│   └── main.hy
└── tests/
    └── test_main.hy
```
