;;;; soko.asd

(asdf:defsystem #:soko
  :description "Describe soko here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :components ((:file "package")
               (:file "soko"))
  :depends-on (:local-time))
