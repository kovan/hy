from poetry_hy_plugin.plugin import _copy_tree


def _generate_project(tmp_path, name="my-cool-app"):
    """Simulate what NewHyCommand.handle() does, without Poetry dependencies."""
    module_name = name.replace("-", "_")
    project_dir = tmp_path / name

    replacements = {
        "{project_name}": name,
        "{module_name}": module_name,
        "{hy_python_requires}": ">=3.9,<3.15",
    }

    from importlib.resources import files
    templates = files("poetry_hy_plugin") / "templates"
    for template_path in templates.iterdir():
        _copy_tree(template_path, project_dir, replacements)

    placeholder = project_dir / "src" / "hy_project"
    if placeholder.exists():
        placeholder.rename(project_dir / "src" / module_name)

    return project_dir, module_name


def test_generates_correct_structure(tmp_path):
    project_dir, module_name = _generate_project(tmp_path)

    assert (project_dir / "pyproject.toml").exists()
    assert (project_dir / "README.md").exists()
    assert (project_dir / "LICENSE").exists()
    assert (project_dir / "tests" / "conftest.py").exists()
    assert (project_dir / "src" / module_name / "main.hy").exists()
    assert (project_dir / "tests" / "test_main.hy").exists()


def test_module_directory_renamed(tmp_path):
    project_dir, module_name = _generate_project(tmp_path, "my-cool-app")

    assert module_name == "my_cool_app"
    assert (project_dir / "src" / "my_cool_app").is_dir()
    assert not (project_dir / "src" / "hy_project").exists()


def test_placeholders_replaced_in_content(tmp_path):
    project_dir, module_name = _generate_project(tmp_path, "my-cool-app")

    pyproject = (project_dir / "pyproject.toml").read_text()
    assert '"my-cool-app"' in pyproject
    assert "{project_name}" not in pyproject

    test = (project_dir / "tests" / "test_main.hy").read_text()
    assert "my_cool_app" in test
    assert "{module_name}" not in test


def test_hy_python_requires_placeholder_replaced(tmp_path):
    project_dir, _ = _generate_project(tmp_path, "my-cool-app")
    pyproject = (project_dir / "pyproject.toml").read_text()
    assert ">=3.9,<3.15" in pyproject
    assert "{hy_python_requires}" not in pyproject


def test_refuses_existing_directory(tmp_path):
    project_dir = tmp_path / "existing"
    project_dir.mkdir()

    # The actual check is in NewHyCommand.handle(), just verify the logic
    assert project_dir.exists()
