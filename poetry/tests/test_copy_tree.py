from poetry_hy_plugin.plugin import _copy_tree


def test_substitutes_placeholders(tmp_path):
    # Set up a fake template directory
    src = tmp_path / "template"
    src.mkdir()
    (src / "hello.txt").write_text("Hello {name}, welcome to {place}!")

    dest = tmp_path / "output"
    replacements = {"{name}": "Alice", "{place}": "Wonderland"}
    _copy_tree(src, dest, replacements)

    result = (dest / "template" / "hello.txt").read_text()
    assert result == "Hello Alice, welcome to Wonderland!"


def test_copies_nested_directories(tmp_path):
    src = tmp_path / "template"
    nested = src / "a" / "b"
    nested.mkdir(parents=True)
    (nested / "file.txt").write_text("deep")

    dest = tmp_path / "output"
    _copy_tree(src, dest, {})

    assert (dest / "template" / "a" / "b" / "file.txt").read_text() == "deep"


def test_no_replacement_when_no_placeholders(tmp_path):
    src = tmp_path / "template"
    src.mkdir()
    (src / "plain.txt").write_text("no placeholders here")

    dest = tmp_path / "output"
    _copy_tree(src, dest, {"{foo}": "bar"})

    assert (dest / "template" / "plain.txt").read_text() == "no placeholders here"
