VENV := .venv
PIP := $(VENV)/bin/pip
PYTHON := $(VENV)/bin/python
PYTEST := $(VENV)/bin/pytest

.PHONY: lint test test-poetry test-hatch test-cookiecutter build build-poetry build-hatch clean release-poetry release-hatch

$(VENV):
	python -m venv $(VENV)
	$(PIP) install -q ruff build

lint: $(VENV)
	$(VENV)/bin/ruff check poetry/src/ poetry/tests/ hatch/src/ hatch/tests/ cookiecutter/hooks/

test: test-poetry test-hatch test-cookiecutter

test-poetry: $(VENV)
	$(PIP) install -q -e ./poetry/ pytest
	$(PYTEST) poetry/tests/

test-hatch: $(VENV)
	$(PIP) install -q -e ./hatch/ pytest
	$(PYTEST) hatch/tests/

test-cookiecutter: $(VENV)
	$(PIP) install -q cookiecutter
	$(VENV)/bin/cookiecutter --no-input cookiecutter/ -o /tmp/cookiecutter-test --overwrite-if-exists
	test -f /tmp/cookiecutter-test/my-hy-project/pyproject.toml
	test -f /tmp/cookiecutter-test/my-hy-project/tests/conftest.py
	test -f /tmp/cookiecutter-test/my-hy-project/src/my_hy_project/__init__.py
	test -f /tmp/cookiecutter-test/my-hy-project/src/my_hy_project/main.hy
	test -f /tmp/cookiecutter-test/my-hy-project/tests/test_main.hy
	@echo "cookiecutter: OK"

build: build-poetry build-hatch

build-poetry: $(VENV)
	$(PYTHON) -m build poetry/

build-hatch: $(VENV)
	$(PYTHON) -m build --wheel hatch/

clean:
	rm -rf $(VENV) poetry/dist/ hatch/dist/ /tmp/cookiecutter-test
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type d -name '*.egg-info' -exec rm -rf {} +

# Usage: make release-poetry VERSION=0.1.2
release-poetry:
	@test -n "$(VERSION)" || (echo "Usage: make release-poetry VERSION=x.y.z" && exit 1)
	sed -i 's/^version = ".*"/version = "$(VERSION)"/' poetry/pyproject.toml
	git add poetry/pyproject.toml
	git commit -m "Release poetry-hy-plugin $(VERSION)"
	git tag poetry/v$(VERSION)
	git push origin main poetry/v$(VERSION)

# Usage: make release-hatch VERSION=0.1.2
release-hatch:
	@test -n "$(VERSION)" || (echo "Usage: make release-hatch VERSION=x.y.z" && exit 1)
	sed -i 's/^version = ".*"/version = "$(VERSION)"/' hatch/pyproject.toml
	git add hatch/pyproject.toml
	git commit -m "Release hatch-hy $(VERSION)"
	git tag hatch/v$(VERSION)
	git push origin main hatch/v$(VERSION)
