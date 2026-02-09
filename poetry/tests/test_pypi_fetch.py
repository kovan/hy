import io
import json
from unittest.mock import patch

import pytest

from poetry_hy_plugin.plugin import _fetch_hy_python_requires


def _make_pypi_response(requires_python):
    data = {"info": {"requires_python": requires_python}}
    body = json.dumps(data).encode()
    resp = io.BytesIO(body)
    resp.read_original = resp.read
    return resp


def test_fetch_hy_python_requires():
    fake_resp = _make_pypi_response(">=3.9,<3.15")
    fake_resp.__enter__ = lambda s: s
    fake_resp.__exit__ = lambda s, *a: None

    with patch("urllib.request.urlopen", return_value=fake_resp):
        result = _fetch_hy_python_requires()

    assert result == ">=3.9,<3.15"


def test_fetch_hy_python_requires_network_error():
    with patch(
        "urllib.request.urlopen",
        side_effect=OSError("Connection refused"),
    ):
        with pytest.raises(RuntimeError, match="Failed to fetch Hy's Python requirement from PyPI"):
            _fetch_hy_python_requires()
