from importlib.resources import files

from hatch.template import File
from hatch.template.plugin.interface import TemplateInterface
from hatch.utils.fs import Path

TEMPLATES = files("hatch_hy") / "templates"


class HyTemplate(TemplateInterface):
    PLUGIN_NAME = "hy"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.plugin_config.setdefault("src-layout", False)

    def initialize_config(self, config):
        pkg = config["package_name"]
        config["package_metadata_file_path"] = f"{pkg}/__about__.hy"

    def get_files(self, config):
        pkg = config["package_name"]
        name = config["project_name_normalized"]
        description = config.get("description", "A Hy project")

        replacements = {
            "{project_name}": name,
            "{module_name}": pkg,
            "{description}": description,
        }

        result = []
        _collect_files(TEMPLATES, Path(), replacements, result)
        self._hy_files = set(id(f) for f in result)
        return result

    def finalize_files(self, config, files):
        pkg = config["package_name"]

        # Remove files from other plugins that conflict with ours
        to_remove = []
        for f in files:
            if id(f) in self._hy_files:
                continue
            name = f.path.name
            # Remove duplicate top-level files we already provide
            if name in ("pyproject.toml", "LICENSE", "LICENSE.txt", "README.md", "conftest.py"):
                to_remove.append(f)
            # Remove default plugin's __about__.py
            elif f.path.parts and f.path.parts[0] == "src" and name == "__about__.py":
                to_remove.append(f)
        for f in to_remove:
            files.remove(f)

        for f in files:
            if f.path and f.path.parts and f.path.parts[0] == "hy_project":
                parts = list(f.path.parts)
                parts[0] = pkg
                f.path = Path(*parts)


def _collect_files(source_dir, rel_path, replacements, result):
    """Walk a template directory and create File objects with substitutions."""
    for entry in source_dir.iterdir():
        entry_rel = rel_path / entry.name if rel_path.parts else Path(entry.name)
        if entry.is_dir():
            _collect_files(entry, entry_rel, replacements, result)
        else:
            content = entry.read_text()
            for old, new in replacements.items():
                content = content.replace(old, new)
            result.append(File(entry_rel, content))
