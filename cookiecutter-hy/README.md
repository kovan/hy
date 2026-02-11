# cookiecutter-hy

A [Cookiecutter](https://github.com/cookiecutter/cookiecutter) template for [Hy](https://hylang.org/) projects.

## Usage

```bash
pip install cookiecutter
cookiecutter gh:kovan/cookiecutter-hy
cd my-hy-project
pip install -e .
my-hy-project
```

To run tests:

```bash
pip install -e ".[test]"
pytest
```

You'll be prompted for:

| Variable | Description |
|----------|-------------|
| `project_name` | Human-readable project name |
| `project_slug` | Package/directory name |
| `module_name` | Python import name |
| `description` | Short description |
| `author` | Author name |
| `version` | Initial version |

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
