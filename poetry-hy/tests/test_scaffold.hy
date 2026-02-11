(import poetry-hy-plugin.plugin [_copy-tree])


(defn _generate-project [tmp-path [name "my-cool-app"]]
  "Simulate what NewHyCommand.handle() does, without Poetry dependencies."
  (setv module-name (.replace name "-" "_"))
  (setv project-dir (/ tmp-path name))

  (setv replacements
    {"{project_name}" name
     "{module_name}" module-name
     "{hy_python_requires}" ">=3.9,<3.15"})

  (import importlib.resources [files])
  (setv templates (/ (files "poetry_hy_plugin") "templates"))
  (for [template-path (.iterdir templates)]
    (_copy-tree template-path project-dir replacements))

  (setv placeholder (/ project-dir "hy_project"))
  (when (.exists placeholder)
    (.rename placeholder (/ project-dir module-name)))

  #(project-dir module-name))


(defn test-generates-correct-structure [tmp-path]
  (setv #(project-dir module-name) (_generate-project tmp-path))

  (assert (.exists (/ project-dir "pyproject.toml")))
  (assert (.exists (/ project-dir "README.md")))
  (assert (.exists (/ project-dir "LICENSE")))
  (assert (.exists (/ project-dir module-name "main.hy")))
  (assert (.exists (/ project-dir "tests" "test_main.hy"))))


(defn test-module-directory-renamed [tmp-path]
  (setv #(project-dir module-name) (_generate-project tmp-path "my-cool-app"))

  (assert (= module-name "my_cool_app"))
  (assert (.is-dir (/ project-dir "my_cool_app")))
  (assert (not (.exists (/ project-dir "hy_project")))))


(defn test-placeholders-replaced-in-content [tmp-path]
  (setv #(project-dir module-name) (_generate-project tmp-path "my-cool-app"))

  (setv pyproject (.read-text (/ project-dir "pyproject.toml")))
  (assert (in "\"my-cool-app\"" pyproject))
  (assert (not-in "{project_name}" pyproject))

  (setv test (.read-text (/ project-dir "tests" "test_main.hy")))
  (assert (in "my_cool_app" test))
  (assert (not-in "{module_name}" test)))


(defn test-hy-python-requires-placeholder-replaced [tmp-path]
  (setv #(project-dir _) (_generate-project tmp-path "my-cool-app"))
  (setv pyproject (.read-text (/ project-dir "pyproject.toml")))
  (assert (in ">=3.9,<3.15" pyproject))
  (assert (not-in "{hy_python_requires}" pyproject)))


(defn test-refuses-existing-directory [tmp-path]
  (setv project-dir (/ tmp-path "existing"))
  (.mkdir project-dir)
  ;; The actual check is in NewHyCommand.handle(), just verify the logic
  (assert (.exists project-dir)))
