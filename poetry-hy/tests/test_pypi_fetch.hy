(import io)
(import json)
(import unittest.mock [patch])

(import pytest)

(import poetry-hy-plugin.plugin [_fetch-hy-python-requires])


(defn _make-pypi-response [requires-python]
  (setv data {"info" {"requires_python" requires-python}})
  (setv body (.encode (json.dumps data)))
  (setv resp (io.BytesIO body))
  (setv resp.read-original resp.read)
  resp)


(defn test-fetch-hy-python-requires []
  (setv fake-resp (_make-pypi-response ">=3.9,<3.15"))
  (setv fake-resp.__enter__ (fn [s] s))
  (setv fake-resp.__exit__ (fn [s #* a] None))

  (with [_ (patch "urllib.request.urlopen" :return-value fake-resp)]
    (setv result (_fetch-hy-python-requires)))

  (assert (= result ">=3.9,<3.15")))


(defn test-fetch-hy-python-requires-network-error []
  (with [_ (patch "urllib.request.urlopen"
                   :side-effect (OSError "Connection refused"))]
    (with [_ (pytest.raises RuntimeError
                             :match "Failed to fetch Hy's Python requirement from PyPI")]
      (_fetch-hy-python-requires))))
