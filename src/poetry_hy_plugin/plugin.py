from __future__ import annotations

import json
import urllib.request
from importlib.resources import files
from pathlib import Path

from cleo.commands.command import Command
from cleo.helpers import argument
from poetry.plugins.application_plugin import ApplicationPlugin

TEMPLATES = files("poetry_hy_plugin") / "templates"


def _fetch_hy_python_requires() -> str:
    """Fetch Hy's Requires-Python from PyPI."""
    url = "https://pypi.org/pypi/hy/json"
    try:
        with urllib.request.urlopen(url, timeout=10) as resp:
            data = json.loads(resp.read())
        requires_python = data["info"]["requires_python"]
    except (urllib.error.URLError, OSError, KeyError, json.JSONDecodeError) as exc:
        raise RuntimeError(
            f"Failed to fetch Hy's Python requirement from PyPI ({url}): {exc}"
        ) from exc
    if not requires_python:
        raise RuntimeError(
            f"PyPI returned no requires_python for Hy ({url})"
        )
    return requires_python


class NewHyCommand(Command):
    name = "new-hy"
    description = "Create a new Hy project"
    arguments = [
        argument("name", "The name of the project"),
    ]

    def handle(self) -> int:
        name = self.argument("name")
        module_name = name.replace("-", "_")
        project_dir = Path(name)

        if project_dir.exists():
            self.line_error(f"<error>Directory '{name}' already exists.</error>")
            return 1

        replacements = {
            "{project_name}": name,
            "{module_name}": module_name,
            "{hy_python_requires}": _fetch_hy_python_requires(),
        }

        # Walk the template tree and copy files with substitutions
        for template_path in TEMPLATES.iterdir():
            _copy_tree(template_path, project_dir, replacements)

        # Rename the placeholder module directory
        placeholder = project_dir / "src" / "hy_project"
        if placeholder.exists():
            placeholder.rename(project_dir / "src" / module_name)

        self.line(f"<info>Created Hy project at</info> <comment>{project_dir}</comment>")
        return 0


def _copy_tree(source, dest_dir, replacements):
    """Recursively copy a template tree, applying text replacements."""
    dest = dest_dir / source.name
    if source.is_dir():
        dest.mkdir(parents=True, exist_ok=True)
        for child in source.iterdir():
            _copy_tree(child, dest, replacements)
    else:
        content = source.read_text()
        for old, new in replacements.items():
            content = content.replace(old, new)
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(content)


class HyPlugin(ApplicationPlugin):
    def activate(self, application):
        application.command_loader.register_factory("new-hy", lambda: NewHyCommand())
