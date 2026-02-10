(import poetry-hy-plugin.plugin [_copy-tree])


(defn test-substitutes-placeholders [tmp-path]
  (setv src (/ tmp-path "template"))
  (.mkdir src)
  (.write-text (/ src "hello.txt") "Hello {name}, welcome to {place}!")

  (setv dest (/ tmp-path "output"))
  (setv replacements {"{name}" "Alice" "{place}" "Wonderland"})
  (_copy-tree src dest replacements)

  (setv result (.read-text (/ dest "template" "hello.txt")))
  (assert (= result "Hello Alice, welcome to Wonderland!")))


(defn test-copies-nested-directories [tmp-path]
  (setv src (/ tmp-path "template"))
  (setv nested (/ src "a" "b"))
  (.mkdir nested :parents True)
  (.write-text (/ nested "file.txt") "deep")

  (setv dest (/ tmp-path "output"))
  (_copy-tree src dest {})

  (assert (= (.read-text (/ dest "template" "a" "b" "file.txt")) "deep")))


(defn test-no-replacement-when-no-placeholders [tmp-path]
  (setv src (/ tmp-path "template"))
  (.mkdir src)
  (.write-text (/ src "plain.txt") "no placeholders here")

  (setv dest (/ tmp-path "output"))
  (_copy-tree src dest {"{foo}" "bar"})

  (assert (= (.read-text (/ dest "template" "plain.txt")) "no placeholders here")))
