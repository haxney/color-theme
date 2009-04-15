;;; muse-setup.el --- Emacs Muse setup to render color-theme website

;; Copyright (C) 2009  Xavier Maillard

;; Author: Xavier Maillard <xma@gnu.org>
;; Keywords: hypermedia

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Code is massively borrowed from Alex Ott.
;; Design and Layout is by Phillipe Brochard
;; Code for lastchange is from http://gunnarwrobel.de/wiki/EmacsMuseMode.html

;;; Code:
(require 'muse-mode)
(require 'muse-html)
(require 'muse-colors)
(require 'muse-wiki)
(require 'muse-latex)
(require 'muse-texinfo)
(require 'muse-docbook)
(require 'muse-project)

(muse-derive-style  "color-theme-xhtml" "xhtml"
                    :header "~/usr/src/color-theme/trunk/doc/website"
                    :footer "~/usr/src/color-theme/trunk/doc/website")


(setq muse-project-alist
      `(
        ("color-theme"
         (,@(muse-project-alist-dirs "~/usr/src/color-theme/trunk/doc/website") :default "index")
         ,@(muse-project-alist-styles "~/usr/src/color-theme/trunk/doc/website"
                                      "~/public_html/color-theme"
                                      "color-theme-xhtml")
         )))

(setq project-menu '(("oddmuse-el" .
                      (("index.html" . "Page principale")))
                     ("color-theme" .
                      (("projects/" . "Main")
                       ("bugs/\?group=" . "Bugs database")
                       ("task/\?group=" . "Tasks")
                       ("patch/\?group=" . "Submit patch")
                       ("files/\?group=" . "Download")))
                     ("records") (())))

(defun muse-mp-generate-savannah-project-menu (project)
  "Automatically generate the website menu based on `PROJECT'."
  (let* ((menu-struct (assoc project project-menu))
         (menu-string "")
         (rel-dir (file-name-directory (muse-wiki-resolve-project-page (muse-project))))
         (rel-path (if (> (length rel-dir) 2)   (substring rel-dir 3) ""))
         (cur-path-muse (muse-current-file))
         (cur-path-html (replace-regexp-in-string "\\.muse" ".html" cur-path-muse))
         )
    (when menu-struct
      (let ((menu-list (if (not (null menu-struct)) (cdr menu-struct))))
        (setq menu-string
              (apply #'concat
                     (mapcar
                      (lambda (x)
                        (concat "<li><a href=\"http://savannah.nongnu.org/"
                                rel-path (car x)
                                project
                                "\">" (cdr x) "</a></li>\n"))
                      menu-list))
              )))
    (concat "<ul>\n\n" menu-string "</ul>")))

(add-to-list 'auto-mode-alist '("\\.muse$" . muse-mode))

(custom-set-variables
 '(muse-html-encoding-default (quote utf-8))
 '(muse-html-meta-content-encoding (quote utf-8))
 '(muse-html-charset-default "utf-8")
 '(muse-file-extension "muse")
 '(muse-mode-auto-p nil)
 '(muse-wiki-allow-nonexistent-wikiword nil)
 '(muse-wiki-use-wikiword nil)
 '(muse-ignored-extensions (quote ("bz2" "gz" "[Zz]" "rej" "orig" "png" "hgignore" "gif"
                                   "css" "jpg" "html" "sh" "lftp" "pdf")))
)

(defun format-time-last-changed ()
  (format-time-string "%Y-%m-%d [%H:%M]"))

(defun insert-last-changed ()
  (insert (format-time-last-changed)))

(defun update-last-changed ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^#lastchange\\s +[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\s \\[[0-9]\\{2\\}:[0-9]\\{2\\}\\]" nil t)
      (delete-region (match-beginning 0) (match-end 0))
      (insert "#lastchange ")
      (insert-last-changed))))

(defun record-last-changed ()
  (setq write-contents-hooks 'update-last-changed))

(setq muse-mode-hook (quote (highlight-changes-mode record-last-changed)))

(provide 'muse-setup)
;;; muse-setup.el ends here
