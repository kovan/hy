(import hatch-hy.template [HyTemplate])


(defn _make-template [[src-layout False]]
  (setv plugin-config {"src-layout" src-layout})
  (HyTemplate plugin-config :cache-dir "/tmp" :creation-time None))


(defn _make-config [[name "my-app"]]
  {"package_name" (.replace name "-" "_")
   "project_name" name
   "project_name_normalized" name
   "description" "A test project"})


(defn test-get-files-returns-all-expected-files []
  (setv t (_make-template))
  (setv config (_make-config))
  (.initialize-config t config)
  (setv files (.get-files t config))

  (setv paths (set (gfor f files (str f.path))))
  (assert (in "pyproject.toml" paths))
  (assert (in "README.md" paths))
  (assert (in "LICENSE" paths))
  (assert (any (gfor p paths (in "conftest.py" p))))
  (assert (any (gfor p paths (in "main.hy" p))))
  (assert (any (gfor p paths (in "test_main.hy" p)))))


(defn test-finalize-renames-module-directory []
  (setv t (_make-template :src-layout True))
  (setv config (_make-config "my-app"))
  (.initialize-config t config)
  (setv files (.get-files t config))
  (.finalize-files t config files)

  (setv paths (lfor f files (str f.path)))
  ;; hy_project should have been renamed to my_app
  (assert (not (any (gfor p paths (in "hy_project" p)))))
  (assert (any (gfor p paths (in "my_app" p)))))


(defn test-placeholders-substituted []
  (setv t (_make-template))
  (setv config (_make-config "my-app"))
  (.initialize-config t config)
  (setv files (.get-files t config))

  (for [f files]
    (assert (not-in "{project_name}" f.contents))
    (assert (not-in "{module_name}" f.contents))
    (assert (not-in "{description}" f.contents))))


(defn test-plugin-name []
  (assert (= HyTemplate.PLUGIN-NAME "hy")))
