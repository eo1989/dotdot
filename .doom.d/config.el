        ;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

        ;; Place your private configuration here! Remember, you do not need to run 'doom
        ;; sync' after modifying this file!


        ;; Some functionality uses this to identify you, e.g. GPG configuration, email
        ;; clients, file templates and snippets.
        (setq user-full-name "Ernest Orlowski"
              user-mail-address "eorlowski6@gmail.com")

        ;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
        ;; are the three important ones:
        ;;
        ;; + `doom-font'
        ;; + `doom-variable-pitch-font'
        ;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
        ;;   presentations or streaming.
        ;;
        ;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
        ;; font string. You generally only need these two:
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font" :size 15)
      doom-serif-font (font-spec :family "JetBrainsMono Nerd Font" :size 15
                                 :weight 'normal)
      doom-unicode-font (font-spec :family "Material Design Icons")
      ivy-posframe-font (font-spec :family "JetBrainsMono Nerd Font")
      doom-one-brighter-comments 't
      ;; doom-one-comment-bg 'nil
      doom-theme 'doom-one
      doom-themes-treemacs-theme "all-the-icons"
      doom-themes-enable-bold 't
      doom-themes-enable-italic 't
      history-length 300
      indent-tabs-mode 'nil
      evil-split-window-below 't
      evil-vsplit-window-right 't
      doom-localleader-key ","
      fira-code-mode--all-ligatures `t
      fira-code-mode-enable-hex-literal nil
      blink-matching-paren `t
      use-package-always-ensure t
      doom-modeline--battery-status 't
      doom-modeline--buffer-file-icon 't
      doom-modeline--flycheck-icon 't
      doom-modeline--helm-buffer-ids 'nil
      doom-modeline--persp-name 'nil
      doom-modeline--lsp 't
      doom-modeline--eglot 'nil
      doom-modeline--tags 'nil
      doom-modeline--vcs-icon 't
      doom-modeline--objed-active 'nil
      doom-modeline--cider 'nil
      doom-modeline--bar-active 't
      doom-modeline--debug-cookie 't
      doom-modeline--debug-dap 't
      doom-modeline--helm-buffer-ids 'nil
      doom-modeline--helm-current-source 'nil
      mac-auto-operator-composition-mode 't
      ivy-mode 1

      org-directory "~/org/"
      display-line-numbers-type `relative
      rainbow-delimiters-mode `1
      cursor-type 'hbar
      cursor-in-non-selected-windows nil
      column-number-mode `t
      x-stretch-cursor `t)
        (require
                'use-package-ensure)

(use-package! lsp-mode
  :commands lsp
  :hook ((python-mode . lsp)
         (julia-mode . lsp)
         (sh-mode . lsp)
         ;; (prog-mode))

        ;; yas-global-mode 't
        ;; lsp-ui-doc-enable 't
        ;; lsp-enable-semantic-highlighting 't
        ;; lsp-lens-auto-enable 't
        ;; lsp-ui-mode 't
        ;; lsp-ui-sideline-enable 't
        ;; lsp-signature-mode 't
        ;; lsp-signature-auto-activate 't
        ;; lsp-enable-snippet 't
        ;; lsp-restart 'auto-restart
        ;; lsp-enable-indentation 1
        ;; lsp-semantic-tokens-enable 1
        ;; lsp-enable-symbol-highlighting 't
        ;; lsp-enable-imenu 't
        ;; lsp-enable-text-document-color 't

        (custom-set-faces!
          '(font-lock-comment-face :slant italic)
          '(font-lock-keyword-face :slant italic))

        (plist-put! +ligatures-extra-symbols
                    :def           nil
                    :and           nil
                    :or            nil
                    :for           nil
                    :not           nil
                    :not-in        nil
                    :true          nil
                    :false         nil
                    :int           nil
                    :float         nil
                    :str           nil
                    :bool          nil
                    :list          nil
                    :yield         nil
                    :union         nil
                    :diff          nil
                    :tuple         nil
                    :pipe          nil
                    :in            nil
                    :quote         nil
                    :quote_end     nil
                    )
        ;; Here are some additional functions/macros that could help you configure Doom:
        ;;
        ;; - `load!' for loading external *.el files relative to this one
        ;; - `use-package!' for configuring packages
        ;; - `after!' for running code after a package has loaded
        ;; - `add-load-path!' for adding directories to the `load-path', relative to
        ;;   this file. Emacs searches the `load-path' when you load packages with
        ;;   `require' or `use-package'.
        ;; - `map!' for binding new keys


        (set-ligatures! 'prog-mode 'org-mode)

(setq global-git-gutter-mode 't
      evil-ex-substitute-global 't
      git-gutter:update-interval 2
      git-gutter:window-width -1
      doom-modeline-major-mode-color-icon 1
      evil-escape-unordered-key-sequence 't)


              ;;   (setq lsp-log-io 'nil)
              ;;   (setq lsp-enable-folding 'nil)
              ;;   (setq lsp-enable-dap-auto-configure 't)
              ;; (setq lsp-eldoc-enable-hover 't)
              ;; (setq lsp-eldoc-render-all 't)
              ;; (setq lsp-enable-relative-indentation 't)
              ;; (setq lsp-enable-xref 1)
        (use-package counsel
          :hook
          (after-init . ivy-mode)
          (counsel-grep-post-action . better-jumper-mode)
          :diminish ivy-mode
          :config
          (setq counsel-find-file-ignore-regexp "\\(?:^[#.]\\)\\|\\(?:[#~]$\\)\\|\\(?:^Icon?\\)"
                counsel-describe-function-function #'helpful-callable
                counsel-describe-variable-function #'helpful-variable
                ;; Add smart-casing (-S) to default command arguments:
                counsel-rg-base-command "rg -S --no-heading --line-number --color always %s ."
                counsel-ag-base-command "ag -S --nocolor --nogroup %s"
                counsel-pt-base-command "pt -S --nocolor --nogroup -e %s"
                counsel-find-file-at-point `t)
          )

        (use-package! ivy-rich
          :config
          (ivy-rich-mode 1)
          (setq ivy-format-function #'ivy-format-function-line)
          )


        ;; first try to indent the current line, and if the line
        ;; was already indented, then try `complete-at-point
        (setq tab-always-indent 'complete)
        ;; (use-package company-tabnine :ensure)
        ;; (add-to-list 'company-backends 'company-tabnine)
        (use-package company-tabnine :ensure
          :init (add-to-list 'company-backends 'company-tabnine) ;; see if this changes anything vs it being above.
          :when (featurep! :completion company)
          :config
          (setq company-tabnine--disable-next-transform nil)
          (defun my-company--transform-candidates (func &rest args)
            (if (not company-tabnine--disable-next-transform)
                (apply func args)
              (setq company-tabnine--disable-next-transform nil)
              (car args)))

          (defun my-company-tabnine (func &rest args)
            (when (eq (car args) 'candidates)
              (setq company-tabnine--disable-next-transform t))
            (apply func args))

          (advice-add #'company--transform-candidates :around #'my-company--transform-candidates)
          (advice-add #'company-tabnine :around #'my-company-tabnine)
          ;; Trigger completion immediately.
          (setq company-idle-delay 0)
          ;; Use the tab-and-go frontend.
          ;; Allows TAB to select and complete at the same time.
          (company-tng-mode 1)
          (setq company-frontends
                '(company-tng-frontend
                  company-pseudo-tooltip-frontend
                  company-echo-metadata-frontend))
          )


        ;; (use-package! company-math
        ;;   :config
        ;;   (defun my-latex-mode-setup ()
        ;;     (setq-local company-backends
        ;;                 (append '((company-math-symbols-latex company-latex-commands))
        ;;                         company-backends)))
        ;;   )

        (add-hook 'evil-normal-state-entry-hook #'company-abort) ;; make aborting less annoying.
        (setq-default history-length 1000)

        ;; '(set-company-backend! '(prog-mode
        ;;                         julia-mode
        ;;                         org-mode)
        ;;   '(
        ;;     company-math-symbols-unicode
        ;;     company-tabnine
        ;;     company-math-symbols-latex
        ;;     company-semantic
        ;;     company-yasnippet
        ;;     company-files
        ;;     ))
        ;; (set-company-backend! '(c-mode, c++-mode, haskell-mode, rust-mode, sh-mode, go-mode, python-mode, lisp-mode, lua-mode, json-mode, clojure-mode, ocaml-mode, yaml-mode)
        ;;   '(company-capf
        ;;     company-files
        ;;     company-yasnippet
        ;;     company-semantic
        ;;     company-tabnine
        ;;     ))
        ;; (setq +lsp-company-backends '(company-capf))
        ;; (setq +lsp-company-backends '(company-capf
        ;;                               company-files
        ;;                               company-yasnippet
        ;;                               company-semantic
        ;;                               company-tabnine
        ;;                               ))

        ;; (setq yas-triggers-in-field 't)


        (use-package! highlight-indent-guides
          :config
          (setq highlight-indent-guides-method 'column)
          (setq highlight-indent-guides-auto-enabled 't)
          (set-face-background 'highlight-indent-guides-even-face "dimgray")
          (set-face-foreground 'highlight-indent-guides-character-face "lightgray")
          )

        (use-package! awesome-pair)
        (setq awesome-tab-mode 't)



        ;; Julia
        ;; (defvar inferior-julia-program-name "julia")

        (use-package julia-mode
          :magic ("%JL" . julia-mode)
          :init
          (setq inferior-julia-program-name 'julia)
          :config
          (define-key julia-mode-map (kbd "TAB") 'julia-latexsub-or-indent)
          :interpreter ("julia" . julia-mode)
          :hook (julia-mode . julia-repl-mode))

        (use-package! lsp-julia
          :config
          (add-hook 'julia-mode-hook #'lsp)
          (setq lsp-julia-default-environment "~/.julia/environments/v1.6")
          (setq lsp-folding-range-limit 100))

        (use-package julia-snail
          :after julia
          :ensure vterm
          :config
          :hook (julia-mode . julia-snail-mode))

        ;; :requires vterm

                                                ; (defun jmd-block-to-jupyter-julia ()
                                                ;   (interactive)
                                                ;   (kmacro-lambda-form [?\C-  ?\C-e backspace ?\C-c ?\C-, ?j down ?\C-  ?\C-s ?` return left ?\C-w up ?\C-y down ?\C-k] 0 "%d"))


        ;; Python
        (add-hook 'python-mode-hook
                  '(lambda()
                     (font-lock-add-keywords
                      nil
                      '(("\\<\\([_A-Za-z0-9]*\\)(" 1
                         font-lock-function-name-face))))) ; highlight function names

        ;; :bind (:map python-mode-map
        ;;        ("C-c <RET>" .0 ))



        ;; (package! lsp-pyright)
        ;; (setq flycheck-python-pylint-executable "flake8")
        ;; (use-package! lsp-pyright
        ;;   :config
        ;;   (setq lsp-clients-python-command "pyright")
        ;;   :hook (python-mode . (lambda ()
        ;;                          (require 'lsp-pyright)
        ;;                          (lsp))))

                                                ; (add-hook 'python-mode #'lsp)
                                                ; (setq +python-ipython-command '("-i" "--color-info"))
                                                ; (setq +python-jupyter-command '("--simple-prompt"))
