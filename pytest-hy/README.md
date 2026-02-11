# pytest-hy

A [pytest](https://docs.pytest.org/) plugin that enables automatic discovery and execution of [Hy](https://hylang.org/) test files (`.hy`).

## Installation

```bash
pip install pytest-hy
```

## Usage

Once installed, pytest will automatically collect and run `.hy` test files — no `conftest.py` needed.

```bash
pytest
```

```hy
;; tests/test_example.hy
(defn test-addition []
  (assert (= (+ 1 2) 3)))
```
