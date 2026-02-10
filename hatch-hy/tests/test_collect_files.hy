(import hatch-hy.template [_collect-files])


(defn _make-fake-dir [tmp-path files-dict]
  "Create a fake template directory with given files."
  (for [#(rel-path content) (.items files-dict)]
    (setv path (/ tmp-path rel-path))
    (.mkdir path.parent :parents True :exist-ok True)
    (.write-text path content))
  tmp-path)


(defn test-collects-flat-files [tmp-path]
  (import hatch.utils.fs [Path :as HatchPath])

  (setv src (_make-fake-dir tmp-path
              {"README.md" "# {project_name}"
               "LICENSE" "MIT"}))

  (setv result [])
  (_collect-files src (HatchPath) {"{project_name}" "cool"} result)

  (setv paths (set (gfor f result (str f.path))))
  (assert (in "README.md" paths))
  (assert (in "LICENSE" paths))

  (setv readme (next (gfor f result :if (= (str f.path) "README.md") f)))
  (assert (= readme.contents "# cool")))


(defn test-collects-nested-files [tmp-path]
  (import hatch.utils.fs [Path :as HatchPath])

  (setv src (_make-fake-dir tmp-path
              {"src/hy_project/__init__.hy" "(print \"hello\")"
               "src/hy_project/main.hy" "(defn main [])"}))

  (setv result [])
  (_collect-files src (HatchPath) {} result)

  (setv paths (set (gfor f result (str f.path))))
  (assert (any (gfor p paths (in "__init__.hy" p))))
  (assert (any (gfor p paths (in "main.hy" p)))))


(defn test-substitutes-all-placeholders [tmp-path]
  (import hatch.utils.fs [Path :as HatchPath])

  (setv src (_make-fake-dir tmp-path
              {"file.txt" "{project_name} by {module_name}: {description}"}))

  (setv replacements
    {"{project_name}" "foo"
     "{module_name}" "foo_mod"
     "{description}" "a thing"})
  (setv result [])
  (_collect-files src (HatchPath) replacements result)

  (assert (= (. (get result 0) contents) "foo by foo_mod: a thing")))
