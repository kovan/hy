# copier-hy

A [Copier](https://copier.readthedocs.io/) template for [Hy](https://hylang.org/) projects.

## Usage

```bash
pip install copier
copier copy gh:kovan/hy/copier-hy my-hy-project
cd my-hy-project
pip install -e .
my-hy-project
```

To run tests:

```bash
pip install -e ".[dev]"
pytest
```

## Usage with uv

You can scaffold and manage the project entirely with [uv](https://docs.astral.sh/uv/) — no global installs needed:

```bash
uvx copier copy gh:kovan/hy/copier-hy my-hy-project
cd my-hy-project
uv sync
uv run my-hy-project
```

To run tests:

```bash
uv sync --extra dev
uv run pytest
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
