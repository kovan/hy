from hatch_hy.template import _collect_files


def _make_fake_dir(tmp_path, files_dict):
    """Create a fake template directory with given files."""
    for rel_path, content in files_dict.items():
        path = tmp_path / rel_path
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)
    return tmp_path


def test_collects_flat_files(tmp_path):
    from hatch.utils.fs import Path as HatchPath

    src = _make_fake_dir(tmp_path, {
        "README.md": "# {project_name}",
        "LICENSE": "MIT",
    })

    result = []
    _collect_files(src, HatchPath(), {"{project_name}": "cool"}, result)

    paths = {str(f.path) for f in result}
    assert "README.md" in paths
    assert "LICENSE" in paths

    readme = next(f for f in result if str(f.path) == "README.md")
    assert readme.contents == "# cool"


def test_collects_nested_files(tmp_path):
    from hatch.utils.fs import Path as HatchPath

    src = _make_fake_dir(tmp_path, {
        "src/hy_project/__init__.hy": "(print \"hello\")",
        "src/hy_project/main.hy": "(defn main [])",
    })

    result = []
    _collect_files(src, HatchPath(), {}, result)

    paths = {str(f.path) for f in result}
    assert any("__init__.hy" in p for p in paths)
    assert any("main.hy" in p for p in paths)


def test_substitutes_all_placeholders(tmp_path):
    from hatch.utils.fs import Path as HatchPath

    src = _make_fake_dir(tmp_path, {
        "file.txt": "{project_name} by {module_name}: {description}",
    })

    replacements = {
        "{project_name}": "foo",
        "{module_name}": "foo_mod",
        "{description}": "a thing",
    }
    result = []
    _collect_files(src, HatchPath(), replacements, result)

    assert result[0].contents == "foo by foo_mod: a thing"
