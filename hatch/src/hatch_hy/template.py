from importlib.resources import files

from hatch.template import File
from hatch.template.plugin.interface import TemplateInterface
from hatch.utils.fs import Path

TEMPLATES = files("hatch_hy") / "templates"


class HyTemplate(TemplateInterface):
    PLUGIN_NAME = "hy"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.plugin_config.setdefault("src-layout", True)

    def initialize_config(self, config):
        pkg = config["package_name"]
        if self.plugin_config["src-layout"]:
            config["readme_file_path"] = "README.md"
            config["package_metadata_file_path"] = f"src/{pkg}/__about__.hy"
        else:
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
        return result

    def finalize_files(self, config, files):
        if self.plugin_config["src-layout"]:
            pkg = config["package_name"]
            for f in files:
                if f.path and f.path.parts and f.path.parts[0] == "src":
                    # Rename placeholder module directory
                    parts = list(f.path.parts)
                    if len(parts) >= 3 and parts[1] == "hy_project":
                        parts[1] = pkg
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
