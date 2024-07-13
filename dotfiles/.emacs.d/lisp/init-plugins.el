;;; init-plugins.el --- Plug-in configuration
;;; Commentary:
;;; Code:
(use-package fanyi
  :ensure t
  :defer t)

(use-package evil
  :ensure t
  :defer nil
  :init
  :config
  (setq evil-want-keybinding nil)
  (evil-mode 1))



(use-package which-key
  :defer nil
  :config
  (setq which-key-allow-evil-operators t)
  (setq which-key-allow-evil-leader t)
  (which-key-mode))

(use-package counsel
  :ensure t)

(use-package ivy
  :ensure t
  :defer nil
  :init
  (ivy-mode 1)
  (counsel-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq search-default-mode #'char-fold-to-regexp)
  (setq ivy-count-format "(%d/%d) ")
  :bind
  (("C-s" . 'swiper)
   ("C-x b" . 'ivy-switch-buffer)
   ("C-c v" . 'ivy-push-view)
   ("C-c s" . 'ivy-switch-view)
   ("C-c V" . 'ivy-pop-view)
   ("C-x C-@" . 'counsel-mark-ring); 在某些终端上 C-x C-SPC 会被映射为 C-x C-@，比如在 macOS 上，所以要手动设置
   ("C-x C-SPC" . 'counsel-mark-ring)
   :map minibuffer-local-map
   ("C-r" . counsel-minibuffer-history)))

(use-package orderless
  :ensure t
  :custom
  (completion-styles
   '(orderless basic))
  (completion-category-overrides
   '((file
      (styles basic partial-completion)))))

(setq ivy-re-builders-alist '((t . orderless-ivy-re-builder)))
(add-to-list 'ivy-highlight-functions-alist '(orderless-ivy-re-builder . orderless-ivy-highlight))

(provide 'init-plugins)
;;; init-plugins.el ends here
