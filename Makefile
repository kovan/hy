VENV := .venv
PIP := $(VENV)/bin/pip
PYTHON := $(VENV)/bin/python
PYTEST := $(VENV)/bin/pytest

.PHONY: lint test test-poetry test-hatch test-cookiecutter test-copier build build-poetry build-hatch clean release-poetry release-hatch

$(VENV):
	python -m venv $(VENV)
	$(PIP) install -q ruff build

lint: $(VENV)
	$(VENV)/bin/ruff check poetry-hy/src/ poetry-hy/tests/ hatch-hy/src/ hatch-hy/tests/ cookiecutter-hy/hooks/

test: test-poetry test-hatch test-cookiecutter test-copier

test-poetry: $(VENV)
	$(PIP) install -q -e ./poetry-hy/ pytest
	$(PYTEST) poetry-hy/tests/

test-hatch: $(VENV)
	$(PIP) install -q -e ./hatch-hy/ pytest
	$(PYTEST) hatch-hy/tests/

test-cookiecutter: $(VENV)
	$(PIP) install -q cookiecutter
	$(VENV)/bin/cookiecutter --no-input cookiecutter-hy/ -o /tmp/cookiecutter-test --overwrite-if-exists
	test -f /tmp/cookiecutter-test/my-hy-project/pyproject.toml
	test -f /tmp/cookiecutter-test/my-hy-project/tests/conftest.py
	test -f /tmp/cookiecutter-test/my-hy-project/src/my_hy_project/__init__.py
	test -f /tmp/cookiecutter-test/my-hy-project/src/my_hy_project/main.hy
	test -f /tmp/cookiecutter-test/my-hy-project/tests/test_main.hy
	@echo "cookiecutter: OK"

test-copier: $(VENV)
	$(PIP) install -q copier
	$(VENV)/bin/copier copy --defaults --vcs-ref HEAD copier-hy/ /tmp/copier-test --overwrite
	test -f /tmp/copier-test/pyproject.toml
	test -f /tmp/copier-test/README.md
	test -f /tmp/copier-test/LICENSE
	test -f /tmp/copier-test/tests/conftest.py
	test -f /tmp/copier-test/src/my_hy_project/__init__.py
	test -f /tmp/copier-test/src/my_hy_project/main.hy
	test -f /tmp/copier-test/tests/test_main.hy
	@echo "copier: OK"

build: build-poetry build-hatch

build-poetry: $(VENV)
	$(PYTHON) -m build poetry-hy/

build-hatch: $(VENV)
	$(PYTHON) -m build --wheel hatch-hy/

clean:
	rm -rf $(VENV) poetry-hy/dist/ hatch-hy/dist/ /tmp/cookiecutter-test /tmp/copier-test
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type d -name '*.egg-info' -exec rm -rf {} +

# Usage: make release-poetry VERSION=0.1.2
release-poetry:
	@test -n "$(VERSION)" || (echo "Usage: make release-poetry VERSION=x.y.z" && exit 1)
	sed -i 's/^version = ".*"/version = "$(VERSION)"/' poetry-hy/pyproject.toml
	git add poetry-hy/pyproject.toml
	git commit -m "Release poetry-hy-plugin $(VERSION)"
	git tag poetry-hy/v$(VERSION)
	git push origin main poetry-hy/v$(VERSION)

# Usage: make release-hatch VERSION=0.1.2
release-hatch:
	@test -n "$(VERSION)" || (echo "Usage: make release-hatch VERSION=x.y.z" && exit 1)
	sed -i 's/^version = ".*"/version = "$(VERSION)"/' hatch-hy/pyproject.toml
	git add hatch-hy/pyproject.toml
	git commit -m "Release hatch-hy $(VERSION)"
	git tag hatch-hy/v$(VERSION)
	git push origin main hatch-hy/v$(VERSION)
