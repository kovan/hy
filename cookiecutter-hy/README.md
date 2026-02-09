# cookiecutter-hy

A [Cookiecutter](https://github.com/cookiecutter/cookiecutter) template for [Hy](https://hylang.org/) projects.

## Usage

```bash
pip install cookiecutter
cookiecutter gh:kovan/hy --directory cookiecutter-hy
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
├── src/
│   └── my_hy_project/
│       ├── __init__.hy
│       └── main.hy
└── tests/
    └── test_main.hy
```

## Getting Started

```bash
cd my-hy-project
pip install -e .
hy src/my_hy_project/main.hy
```
