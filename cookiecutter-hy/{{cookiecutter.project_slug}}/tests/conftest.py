from pathlib import Path

import hy
import pytest

TESTS_DIR = Path.cwd() / "tests"


def pytest_collect_file(file_path, parent):
    if file_path.suffix == ".hy" and TESTS_DIR in file_path.parents:
        return pytest.Module.from_parent(parent, path=file_path)
