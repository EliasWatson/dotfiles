;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(add-to-list 'default-frame-alist '(undecorated . t))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14)
      doom-variable-pitch-font (font-spec :family "SF Pro Display" :size 18))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Swap Super and Meta to prevent conflicts with Aerospace (tiling window manager)
(setq mac-option-modifier 'super  ; Make Option key act as Super
      mac-command-modifier 'meta) ; Make Command key act as Meta

;; Switch C-<backspace> and s-<backspace>
(with-eval-after-load 'evil
  (define-key evil-insert-state-map (kbd "M-<backspace>") 'kill-whole-line)  ; Cmd+Backspace deletes line
  (define-key evil-insert-state-map (kbd "s-<backspace>") 'backward-kill-word)) ; Option+Backspace deletes word

(setq display-time-load-average nil)
(display-time)

(use-package! doom-modeline
  :config
  (setq doom-modeline-height 25))

;; Adjust the size of Org headings
(custom-set-faces!
  '(org-level-1 :inherit outline-1 :height 1.3) ; 4px above, 4px below
  '(org-level-2 :inherit outline-2 :height 1.2) ; 3px above, 3px below
  '(org-level-3 :inherit outline-3 :height 1.1) ; 2px above, 2px below
  '(org-level-4 :inherit outline-4 :height 1.05)) ; 1px above, 1px below

(use-package! org-modern
  :after org
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "○" "✸" "✿" "◇")) ; Use characters your font supports
  (global-org-modern-mode))

(setq org-startup-indented t)

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(use-package! lsp-tailwindcss :after lsp-mode)

(after! org
  (add-to-list 'org-capture-templates
               '("i" "Idea" entry
                 (file+headline "~/org/ideas.org" "Ideas")
                 "* IDEA %?\n  %U\n"
                 :empty-lines 1)))

(setq org-log-done 'time)

(after! lsp-mode
  (add-hook 'typescript-mode-hook
            (lambda ()
              (setq-local typescript-indent-level 2))))

(use-package! visual-fill-column
  :config
  ;; Center text for all buffers
  (setq-default visual-fill-column-center-text t)
  ;; Ensure sensible behavior with window splits
  (setq visual-fill-column-enable-sensible-window-split t)
  ;; Function to set width based on major mode
  (defun my-set-visual-fill-column-width ()
    (cond
     ((derived-mode-p 'org-mode)
      (setq-local visual-fill-column-width 80))  ; Width 80 for Org mode
     ((derived-mode-p 'prog-mode)
      (setq-local visual-fill-column-width 120)) ; Width 120 for code files
     (t
      (setq-local visual-fill-column-width 80)))) ; Default width for other files
  ;; Enable visual-fill-column-mode and set width for all file buffers
  :hook
  (find-file-hook . (lambda ()
                      (visual-fill-column-mode 1)
                      (my-set-visual-fill-column-width))))
