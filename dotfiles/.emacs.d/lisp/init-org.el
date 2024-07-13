;;; org-config --- org plugin config
;;; Commentary:
;;; Code:

(use-package org
  :ensure t
  :init (setq evil-want-C-i-jump nil)
  :config
  ;;; Config
  ;; General
					; auto linefeed on org mode
  (add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))

  (setq org-agenda-files '("~/Documents/org/todo.org"
                           "~/Documents/org/inbox.org")
	org-agenda-time-grid (quote ((daily today require-timed)
                                     (300
                                      600
                                      900
                                      1200
                                      1500
                                      1800
                                      2100
                                      2400)
                                     "......"
                                     "-----------------------------------------------------"
                                     ))
	org-agenda-custom-commands '(("u" "Unscheduled TODOs"
				      ((tags-todo "-SCHEDULED/!TODO"
						  ((org-agenda-overriding-header "Unscheduled TODOs"))))))
  org-capture-templates '(
                          ("i" "inbox" entry (file "~/Documents/org/inbox.org")
                           "* %^{headline} %^g \n\n%? \n\n%U" :empty-lines 1)
                          ("t" "todo" entry (file+datetree "~/Documents/org/todo.org")
                           "* TODO [#B] %U %i%?" :empty-lines 1)
                          ("s" "someday" entry (file+headline "~/Documents/org/maybe.org" "someday")
                           "* [#C] %U %i%?" :empty-lines 1)
                          ("r" "reference" entry (file+headline "~/Documents/org/reference.org" "reference")
                           "* [#C] %U %i%?" :empty-lines 1)
                          ("e" "repeat" entry (file+headline "~/Documents/org/repeat.org" "repeat")
                           "* [#C] %U %i%?" :empty-lines 1))
  org-refile-targets '(
                       ("~/Documents/org/inbox.org" :maxlevel . 2)
		       ("~/Documents/org/maybe.org" :maxlevel . 9)
		       ("~/Documents/org/reference.org" :maxlevel . 9)
		       ("~/Documents/org/todo.org" :maxlevel . 9)
		       ("~/Documents/org/project.org" :maxlevel . 9)
		       )
  org-refile-use-outline-path 'file
  org-outline-path-complete-in-steps nil
  org-refile-allow-creating-parent-nodes 'confirm
  org-todo-keywords '((sequence "TODO(t/!)" "DOING(i/!)" "SCHEDLED(s/!)" "|" "DONE(d@/!)" "CANCEL(c@/!)"))
  org-todo-keyword-faces '(
                           ("DOING" . (:foreground "#eec78e" :weight bold))
                           ("CANCEL" . (:foreground "#4C566A" :weight bold))
                           ("SCHEDLED" . (:foreground "#6495ED" :weight bold)))
  org-enforce-todo-dependencies t
  )

  ;;; Shortcutkey setting

;; Leader
(evil-define-key '(normal visual motion) org-mode-map (kbd "SPC") nil) 
(evil-set-leader '(normal insert motion) (kbd "SPC"))

  ;;; Basic opt
;; Cycling org-cycle
(evil-define-key 'normal org-mode-map
  (kbd "TAB") 'org-cycle)
					; Execute Command
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>g;") 'evil-ex) 
					; open agency
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>ga") 'org-agenda)
					; set property
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>gP") 'org-set-property)
					;  code block
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>gc") 'org--src-block)
					; tag view
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>gt") 'org-tags-view)
					; Headline
					; move up headline
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>gK") 'org-move-subtree-up)
					; move down headline
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>gJ") 'org-move-subtree-down)
					; Capture
					; open capture
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>gp") 'org-capture)

;; Refile
					; refile to targets
(evil-define-key 'normal org-mode-map
  (kbd "<leader>rr") 'org-refile)
					; refile to todo.org
(evil-define-key 'normal org-mode-map
  (kbd "<leader>rt") 'he/org-refile-to-datetree)

;; Clock
					; start
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>cs") 'org-clock-in)
					; end
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>ce") 'org-clock-out)
					; cancel
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>cc") 'org-clock-cancel)
					; goto
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>cg") 'org-clock-goto)
					; report
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>cr") 'org-clock-report)

;; Other
					; Dict
					; search word
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>ew") 'fanyi-dwim2)
					; search word
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>et") 'modus-themes-toggle)

;; Project
					; find file
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>pf") 'project-find-file)
					; switch project
(evil-define-key '(normal ) org-mode-map
  (kbd "<leader>pw") 'project-switch-project)
)

(defun he/org-read-datetree-date (d)
  (let ((dtmp (nthcdr 3 (parse-time-string d))))
    (list (cadr dtmp) (car dtmp) (caddr dtmp))))

;; refile 一个 entry 到 gtd.org 文件
(defun he/org-refile-to-datetree (&optional bfn)
  (interactive)
  (require 'org-datetree)
  (let* ((bfn (or bfn (find-file-noselect (expand-file-name "~/Documents/org/todo.org"))))
	 (datetree-date (he/org-read-datetree-date (org-read-date t nil))))
    (org-refile nil nil (list nil (buffer-file-name bfn) nil
			      (with-current-buffer bfn
				(save-excursion
				  (org-datetree-find-date-create datetree-date)
				  (point)))))))

(defun org-insert-src-block (src-code-type)
  "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
  (interactive
   (let ((src-code-types
          '("emacs-lisp" "python" "C" "sh" "java" "js" "clojure" "C++" "css"
            "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
            "octave" "oz" "plantuml" "R" "sass" "screen" "sql" "awk" "ditaa"
            "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
            "Scheme" "sqlite" "lua")))
     (list (ido-completing-read "Source code type: " src-code-types))))
  (progn
    (newline-and-indent)
    (insert (format "#+BEGIN_SRC %s\n" src-code-type))
    (newline-and-indent)
    (insert "#+END_SRC\n")
    (previous-line 2)
    (org-edit-src-code)))

;; org-roam
(use-package org-roam
  :ensure t ;; 自动安装
  :custom
  (org-roam-directory "~/Documents/org/notes/") ;; 默认笔记目录, 提前手动创建好
  (org-roam-dailies-directory "daily/") ;; 默认日记目录, 上一目录的相对路径
  (org-roam-db-gc-threshold most-positive-fixnum) ;; 提高性能
  :bind (("C-c n f" . org-roam-node-find)
         ;; 如果你的中文输入法会拦截非 ctrl 开头的快捷键, 也可考虑类似如下的设置
         ;; ("C-c C-n C-f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n l" . org-roam-buffer-toggle) ;; 显示后链窗口
         ("C-c n u" . org-roam-ui-mode)) ;; 浏览器中可视化
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map) ;; 日记菜单
  :config
  (require 'org-roam-dailies)  ;; 启用日记功能
  (org-roam-db-autosync-mode)) ;; 启动时自动同步数据库

(use-package org-roam-ui
  :ensure t ;; 自动安装
  :after org-roam
  :custom
  (org-roam-ui-sync-theme t) ;; 同步 Emacs 主题
  (org-roam-ui-follow t) ;; 笔记节点跟随
  (org-roam-ui-update-on-save t))

;; Theme
(use-package doom-themes
  :ensure t
  :defer nil
  :config
  (load-theme 'doom-one-light t))

;; Basic
(setq
 ;;org-startup-indented t
 ;;org-src-tab-acts-natively nil
 org-hide-emphasis-markers t
 org-fontify-done-headline t
 org-hide-leading-stars nil
 org-pretty-entities t
 ;;org-agenda-show-inherited-tags nili
 )

;; Modern Org Mode theme
;;(use-package org-modern
;;  :ensure t
;;  :init
;;  (setopt org-modern-table-vertical 2)
;;  (setopt org-modern-tag nil)
;;  (setopt org-modern-todo nil)
;;  (setopt org-modern-block-name nil)
;;  (setopt org-modern-keyword nil)
;;  (setopt org-modern-timestamp nil)
;;  (setopt org-modern-block-fringe nil)
;;  :config (global-org-modern-mode 1))

(setq custom-file "~/.emacs.d/lisp/custom.el")
(load custom-file)

(provide 'init-org)
;;; init-org.el ends here
