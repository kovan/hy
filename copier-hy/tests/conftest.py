from pathlib import Path

import hy  # noqa: F401
import pytest

TESTS_DIR = Path(__file__).resolve().parent


def pytest_collect_file(file_path, parent):
    if file_path.suffix == ".hy" and TESTS_DIR in (file_path.resolve()).parents:
        return pytest.Module.from_parent(parent, path=file_path)
