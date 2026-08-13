;;; ox-rlr-typst-tests.el --- Tests for ox-rlr-typst -*- lexical-binding: t; -*-

;;; Commentary:

;; Golden-file tests: every Org file under `test/fixtures' is exported
;; with the `rlr-typst' back-end and compared against the `.typ' file of
;; the same name under `test/expected'.
;;
;; Run them with:
;;
;;     make test
;;
;; or directly:
;;
;;     emacs -Q --batch -L . -l test/ox-rlr-typst-tests.el \
;;           -f ert-run-tests-batch-and-exit
;;
;; When a change is *meant* to alter the output, refresh the expected
;; files rather than editing them by hand, then read the diff:
;;
;;     make regenerate && git diff test/expected
;;
;; If the `typst' binary is on PATH, a final test also compiles each
;; expected file, so the fixtures are checked for being valid Typst and
;; not merely unchanged.  That test is skipped when it is not.

;;; Code:

(require 'ert)
(require 'ox-rlr-typst)

(defconst ox-rlr-typst-tests-dir
  (file-name-directory (or load-file-name buffer-file-name))
  "Directory holding this test file.")

(defun ox-rlr-typst-tests--fixtures ()
  "Return the absolute path of every fixture Org file."
  (directory-files (expand-file-name "fixtures" ox-rlr-typst-tests-dir)
                   t "\\.org\\'"))

(defun ox-rlr-typst-tests--expected-file (fixture)
  "Return the expected `.typ' file matching FIXTURE."
  (expand-file-name (concat (file-name-base fixture) ".typ")
                    (expand-file-name "expected" ox-rlr-typst-tests-dir)))

(defun ox-rlr-typst-tests--export (fixture)
  "Export FIXTURE with the `rlr-typst' back-end and return the result.
The fixture is visited rather than inserted into a scratch buffer so
that `#+NAME' resolution and relative file links behave as they do in
real use."
  (let ((org-export-with-broken-links nil)
        ;; Keep the run independent of the machine it happens on: the
        ;; template falls back to `user-full-name' when a document has no
        ;; `#+AUTHOR' (every fixture sets one, but be explicit).
        (user-full-name "Test Author"))
    (with-temp-buffer
      (insert-file-contents fixture)
      (setq buffer-file-name fixture)
      (let ((default-directory (file-name-directory fixture)))
        (org-mode)
        (unwind-protect
            (org-export-as 'rlr-typst)
          (setq buffer-file-name nil))))))

(defun ox-rlr-typst-tests--diff (expected actual)
  "Return a readable diff between EXPECTED and ACTUAL strings."
  (let ((expected-file (make-temp-file "ox-rlr-typst-expected"))
        (actual-file (make-temp-file "ox-rlr-typst-actual")))
    (unwind-protect
        (progn
          (with-temp-file expected-file (insert expected))
          (with-temp-file actual-file (insert actual))
          (with-temp-buffer
            (call-process "diff" nil t nil "-u"
                          "--label" "expected" expected-file
                          "--label" "actual" actual-file)
            (buffer-string)))
      (delete-file expected-file)
      (delete-file actual-file))))

(defun ox-rlr-typst-tests-regenerate ()
  "Rewrite every expected `.typ' file from the current exporter output.
Intended to be run from `make regenerate'; always inspect the resulting
`git diff test/expected' before committing it."
  (dolist (fixture (ox-rlr-typst-tests--fixtures))
    (let ((out (ox-rlr-typst-tests--expected-file fixture)))
      (make-directory (file-name-directory out) t)
      (with-temp-file out (insert (ox-rlr-typst-tests--export fixture)))
      (message "Wrote %s" (file-relative-name out ox-rlr-typst-tests-dir)))))

(ert-deftest ox-rlr-typst-test-fixtures-match-expected ()
  "Each fixture exports to exactly its expected `.typ' file."
  (dolist (fixture (ox-rlr-typst-tests--fixtures))
    (let* ((expected-file (ox-rlr-typst-tests--expected-file fixture))
           (name (file-name-nondirectory fixture)))
      (should (file-exists-p expected-file))
      (let ((expected (with-temp-buffer
                        (insert-file-contents expected-file)
                        (buffer-string)))
            (actual (ox-rlr-typst-tests--export fixture)))
        (unless (equal expected actual)
          (ert-fail
           (format "%s exported differently than expected:\n%s\n\
Run `make regenerate' if this change is intended."
                   name (ox-rlr-typst-tests--diff expected actual))))))))

(ert-deftest ox-rlr-typst-test-expected-output-compiles ()
  "Every expected `.typ' file compiles with the real `typst' binary.
Skipped when `typst' is not installed."
  (skip-unless (executable-find "typst"))
  (dolist (fixture (ox-rlr-typst-tests--fixtures))
    (let* ((expected-file (ox-rlr-typst-tests--expected-file fixture))
           ;; Typst resolves `image("img.png")' relative to the `.typ' file
           ;; itself, so compile a copy sitting where a real export would put
           ;; it: right beside the Org source.
           (copy (make-temp-file
                  (expand-file-name "compile-check-" (file-name-directory fixture))
                  nil ".typ"))
           (pdf (make-temp-file "ox-rlr-typst" nil ".pdf"))
           (output nil)
           (status nil))
      (unwind-protect
          (progn
            (copy-file expected-file copy t)
            (with-temp-buffer
              (setq status (call-process "typst" nil t nil "compile" copy pdf))
              (setq output (buffer-string)))
            (unless (eq status 0)
              (ert-fail (format "typst failed on %s:\n%s"
                                (file-name-nondirectory expected-file) output))))
        (when (file-exists-p copy) (delete-file copy))
        (when (file-exists-p pdf) (delete-file pdf))))))

(provide 'ox-rlr-typst-tests)
;;; ox-rlr-typst-tests.el ends here
