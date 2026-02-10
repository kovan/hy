# hatch-hy

A [Hatch](https://hatch.pypa.io/) template plugin for [Hy](https://hylang.org/) projects.

> **Note:** This plugin uses Hatch's undocumented template plugin API. It has been tested with Hatch 1.x but the API may change.

## Installation

```bash
pipx inject hatch hatch-hy
hatch config set template.plugins.hy.src-layout true
```

## Usage

```bash
hatch new my-hy-project
```

## Generated Structure

```
my-hy-project/
├── pyproject.toml
├── README.md
├── LICENSE
├── src/
│   └── my_hy_project/
│       ├── __init__.py
│       └── main.hy
└── tests/
    ├── conftest.py
    └── test_main.hy
```
