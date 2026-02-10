# copier-hy

A [Copier](https://copier.readthedocs.io/) template for [Hy](https://hylang.org/) projects.

## Usage

```bash
pip install copier
copier copy gh:kovan/hy/copier-hy my-hy-project
```

You'll be prompted for:

| Variable | Default | Description |
|----------|---------|-------------|
| `project_name` | My Hy Project | Human-readable project name |
| `project_slug` | my-hy-project | Package/directory name |
| `module_name` | my_hy_project | Python import name |
| `description` | A Hy project | Short description |
| `author` | Your Name | Author name |
| `version` | 0.1.0 | Initial version |

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
    ├── conftest.py
    └── test_main.hy
```

## Getting Started

```bash
cd my-hy-project
pip install -e .
my-hy-project
```
