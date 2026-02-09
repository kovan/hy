from hatch_hy.template import HyTemplate


def _make_template(src_layout=True):
    plugin_config = {"src-layout": src_layout}
    t = HyTemplate(plugin_config, cache_dir="/tmp", creation_time=None)
    return t


def _make_config(name="my-app"):
    return {
        "package_name": name.replace("-", "_"),
        "project_name": name,
        "project_name_normalized": name,
        "description": "A test project",
    }


def test_get_files_returns_all_expected_files():
    t = _make_template()
    config = _make_config()
    t.initialize_config(config)
    files = t.get_files(config)

    paths = {str(f.path) for f in files}
    assert "pyproject.toml" in paths
    assert "README.md" in paths
    assert "LICENSE" in paths
    assert "conftest.py" in paths
    assert any("__init__.hy" in p for p in paths)
    assert any("main.hy" in p for p in paths)
    assert any("test_main.hy" in p for p in paths)


def test_finalize_renames_module_directory():
    t = _make_template(src_layout=True)
    config = _make_config("my-app")
    t.initialize_config(config)
    files = t.get_files(config)
    t.finalize_files(config, files)

    paths = [str(f.path) for f in files]
    # hy_project should have been renamed to my_app
    assert not any("hy_project" in p for p in paths)
    assert any("my_app" in p for p in paths)


def test_placeholders_substituted():
    t = _make_template()
    config = _make_config("my-app")
    t.initialize_config(config)
    files = t.get_files(config)

    for f in files:
        assert "{project_name}" not in f.contents
        assert "{module_name}" not in f.contents
        assert "{description}" not in f.contents


def test_plugin_name():
    assert HyTemplate.PLUGIN_NAME == "hy"
