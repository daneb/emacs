(add-to-list 'load-path "~/.config/emacs/scripts/")

(require 'elpaca-setup)  ;; The Elpaca Package Manager
(require 'buffer-move)   ;; Buffer-move for better window management

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(setq backup-directory-alist '((".*" . "~/.local/share/Trash/files")))
(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))

(setq version-control t     ;; Use version numbers for backups.
      kept-new-versions 10  ;; Number of newest versions to keep.
      kept-old-versions 0   ;; Number of oldest versions to keep.
      delete-old-versions t ;; Don't ask to delete excess backup versions.
      backup-by-copying t)  ;; Copy all files, don't rename them.
(setq vc-make-backup-files t)

(use-package company
  :diminish
  :hook (typescript-mode . company-mode)
  :custom
  (company-idle-delay 0.5)  ; Increased delay before completion starts
  (company-minimum-prefix-length 3)  ; Increased minimum prefix length
  (company-show-numbers t)
  (company-tooltip-align-annotations 't)
  :config
  (global-company-mode t))

(use-package company-box
  :after company
  :diminish
  :hook (company-mode . company-box-mode))

;; Debugging helpers
(defun my/eglot-capabilites ()
  "Print Eglot server capabilities for the current buffer."
  (interactive)
  (if eglot--managed-mode
      (message "Eglot server capabilities: %S" 
               (eglot--server-capable :completionProvider))
    (message "Eglot is not active in this buffer.")))

(use-package company-quickhelp
  :after company
  :config
  (company-quickhelp-mode))

(defun my/company-diag ()
  "Print Company diagnostics for the current buffer."
  (interactive)
  (if (bound-and-true-p company-mode)
      (message "Company Backends: %S" company-backends)
    (message "Company mode is not active in this buffer.")))

(setq completion-category-overrides '((eglot (styles basic))))

(use-package dashboard
  :ensure t
  :init
  (setq initial-buffer-choice 'dashboard-open)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "Emacs Is More Than A Text Editor!")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner "~/.config/emacs/images/emacs-dash.png")  ;; use custom image as banner
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (bookmarks . 3)
                          (projects . 3)
                          (registers . 3)))
  :custom
  (dashboard-modify-heading-icons '((recents . "file-text")
				      (bookmarks . "book")))
  :config
  (dashboard-setup-startup-hook))

(use-package diminish)

(use-package dired-open
  :config
  (setq dired-open-extensions '(("gif" . "sxiv")
                                ("jpg" . "sxiv")
                                ("png" . "sxiv")
                                ("mkv" . "mpv")
                                ("mp4" . "mpv"))))

(use-package peep-dired
  :after dired
  :hook (evil-normalize-keymaps . peep-dired-hook)
  :config
    (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
    (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
    (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
    (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file)
)

(use-package elfeed
  :config
  (setq elfeed-search-feed-face ":foreground #ffffff :weight bold"
        elfeed-feeds (quote
                       (("https://www.reddit.com/r/linux.rss" reddit linux)
                        ("https://www.reddit.com/r/commandline.rss" reddit commandline)
                        ("https://www.reddit.com/r/distrotube.rss" reddit distrotube)
                        ("https://www.reddit.com/r/emacs.rss" reddit emacs)
                        ("https://www.gamingonlinux.com/article_rss.php" gaming linux)
                        ("https://hackaday.com/blog/feed/" hackaday linux)
                        ("https://opensource.com/feed" opensource linux)
                        ("https://linux.softpedia.com/backend.xml" softpedia linux)
                        ("https://itsfoss.com/feed/" itsfoss linux)
                        ("https://www.zdnet.com/topic/linux/rss.xml" zdnet linux)
                        ("https://www.phoronix.com/rss.php" phoronix linux)
                        ("http://feeds.feedburner.com/d0od" omgubuntu linux)
                        ("https://www.computerworld.com/index.rss" computerworld linux)
                        ("https://www.networkworld.com/category/linux/index.rss" networkworld linux)
                        ("https://www.techrepublic.com/rssfeeds/topic/open-source/" techrepublic linux)
                        ("https://betanews.com/feed" betanews linux)
                        ("http://lxer.com/module/newswire/headlines.rss" lxer linux)
                        ("https://distrowatch.com/news/dwd.xml" distrowatch linux)))))


(use-package elfeed-goodies
  :init
  (elfeed-goodies/setup)
  :config
  (setq elfeed-goodies/entry-pane-size 0.5))

;; Expands to: (use-package evil (use-package evil :demand t))
(use-package evil
    :init      ;; tweak evil's configuration before loading it
    (setq evil-want-integration t  ;; This is optional since it's already set to t by default.
          evil-want-keybinding nil
          evil-vsplit-window-right t
          evil-split-window-below t
          evil-undo-system 'undo-redo)  ;; Adds vim-like C-r redo functionality
    (evil-mode))

(use-package evil-collection
  :after evil
  :config
  ;; Do not uncomment this unless you want to specify each and every mode
  ;; that evil-collection should works with.  The following line is here
  ;; for documentation purposes in case you need it.
  ;; (setq evil-collection-mode-list '(calendar dashboard dired ediff info magit ibuffer))
  (add-to-list 'evil-collection-mode-list 'help) ;; evilify help mode
  (evil-collection-init))

(use-package evil-tutor)

;; Using RETURN to follow links in Org/Evil
;; Unmap keys in 'evil-maps if not done, (setq org-return-follows-link t) will not work
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))
;; Setting RETURN key in org-mode to follow links
  (setq org-return-follows-link  t)

(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :init (global-flycheck-mode))

;; Set default font
(set-face-attribute 'default nil
                    :family "JetBrains Mono"
                    :height 140
                    :weight 'normal
                    :width 'normal)

;; Set variable-pitch font
(set-face-attribute 'variable-pitch nil
                    :family "Cantarell"
                    :height 150
                    :weight 'normal
                    :width 'normal)

;; Set fixed-pitch font
(set-face-attribute 'fixed-pitch nil
                    :family "JetBrains Mono"
                    :height 140
                    :weight 'normal
                    :width 'normal)

;; Set font for code
(set-face-attribute 'font-lock-comment-face nil
                    :slant 'italic
                    :foreground "#8B8B8B")
(set-face-attribute 'font-lock-keyword-face nil
                    :slant 'italic
                    :weight 'bold)

;; Ensure unicode fonts are used
(use-package unicode-fonts
  :ensure t
  :config
  (unicode-fonts-setup))

;; Ligatures (if you're using Emacs 27 or later)
(use-package ligature
  :ensure t
  :config
  ;; Enable ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
                                       ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
                                       "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
                                       "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
                                       "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
                                       "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
                                       "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
                                       "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
                                       "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
                                       "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))
  (global-ligature-mode 't))

;; Scale text for better readability
(use-package default-text-scale
  :ensure t
  :config
  (default-text-scale-mode))

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(use-package general
  :config
  (general-evil-setup)

  ;; set up 'SPC' as the global leader key
  (general-create-definer db/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :global-prefix "M-SPC") ;; access leader in insert mode

  (db/leader-keys
    "SPC" '(counsel-M-x :wk "Counsel M-x")
    "." '(find-file :wk "Find file")
    "=" '(perspective-map :wk "Perspective") ;; Lists all the perspective keybindings
    "TAB TAB" '(comment-line :wk "Comment lines")
    "u" '(universal-argument :wk "Universal argument"))

  (db/leader-keys
    "b" '(:ignore t :wk "Bookmarks/Buffers")
    "b b" '(switch-to-buffer :wk "Switch to buffer")
    "b c" '(clone-indirect-buffer :wk "Create indirect buffer copy in a split")
    "b C" '(clone-indirect-buffer-other-window :wk "Clone indirect buffer in new window")
    "b d" '(bookmark-delete :wk "Delete bookmark")
    "b i" '(ibuffer :wk "Ibuffer")
    "b k" '(kill-current-buffer :wk "Kill current buffer")
    "b K" '(kill-some-buffers :wk "Kill multiple buffers")
    "b l" '(list-bookmarks :wk "List bookmarks")
    "b m" '(bookmark-set :wk "Set bookmark")
    "b n" '(next-buffer :wk "Next buffer")
    "b p" '(previous-buffer :wk "Previous buffer")
    "b r" '(revert-buffer :wk "Reload buffer")
    "b R" '(rename-buffer :wk "Rename buffer")
    "b s" '(basic-save-buffer :wk "Save buffer")
    "b S" '(save-some-buffers :wk "Save multiple buffers")
    "b w" '(bookmark-save :wk "Save current bookmarks to bookmark file"))
  
(db/leader-keys
    ;; Eglot binding (just the main entry point)
    "c" '(eglot-hydra/body :wk "Eglot menu"))

    ;; Add which-key description for the main Eglot entry point
    (with-eval-after-load 'which-key
    (which-key-add-key-based-replacements
        "SPC c" "Eglot menu"))


  (db/leader-keys
    "d" '(:ignore t :wk "Dired")
    "d d" '(dired :wk "Open dired")
    "d j" '(dired-jump :wk "Dired jump to current")
    "d n" '(neotree-dir :wk "Open directory in neotree")
    "d p" '(peep-dired :wk "Peep-dired"))

  (db/leader-keys
    "e" '(:ignore t :wk "Eshell/Evaluate")
    "e b" '(eval-buffer :wk "Evaluate elisp in buffer")
    "e d" '(eval-defun :wk "Evaluate defun containing or after point")
    "e e" '(eval-expression :wk "Evaluate and elisp expression")
    "e h" '(counsel-esh-history :which-key "Eshell history")
    "e l" '(eval-last-sexp :wk "Evaluate elisp expression before point")
    "e r" '(eval-region :wk "Evaluate elisp in region")
    "e R" '(eww-reload :which-key "Reload current page in EWW")
    "e s" '(eshell :which-key "Eshell")
    "e w" '(eww :which-key "EWW emacs web wowser"))

  (db/leader-keys
    "f" '(:ignore t :wk "Files")
    "f c" '((lambda () (interactive)
              (find-file "~/.config/emacs/config.org"))
            :wk "Open emacs config.org")
    "f e" '((lambda () (interactive)
              (dired "~/.config/emacs/"))
            :wk "Open user-emacs-directory in dired")
    "f d" '(find-grep-dired :wk "Search for string in files in DIR")
    "f g" '(counsel-grep-or-swiper :wk "Search for string current file")
    "f i" '((lambda () (interactive)
              (find-file "~/.config/emacs/init.el"))
            :wk "Open emacs init.el")
    "f j" '(counsel-file-jump :wk "Jump to a file below current directory")
    "f l" '(counsel-locate :wk "Locate a file")
    "f r" '(counsel-recentf :wk "Find recent files")
    "f u" '(sudo-edit-find-file :wk "Sudo find file")
    "f U" '(sudo-edit :wk "Sudo edit file")
    "f f" '(counsel-projectile-find-file :wk "find file in project")
    "f s" '(counsel-projectile-rg :wk "search text in project"))

  (db/leader-keys
    "g" '(:ignore t :wk "Git")
    "g /" '(magit-displatch :wk "Magit dispatch")
    "g ." '(magit-file-displatch :wk "Magit file dispatch")
    "g b" '(magit-branch-checkout :wk "Switch branch")
    "g c" '(:ignore t :wk "Create")
    "g c b" '(magit-branch-and-checkout :wk "Create branch and checkout")
    "g c c" '(magit-commit-create :wk "Create commit")
    "g c f" '(magit-commit-fixup :wk "Create fixup commit")
    "g C" '(magit-clone :wk "Clone repo")
    "g f" '(:ignore t :wk "Find")
    "g f c" '(magit-show-commit :wk "Show commit")
    "g f f" '(magit-find-file :wk "Magit find file")
    "g f g" '(magit-find-git-config-file :wk "Find gitconfig file")
    "g F" '(magit-fetch :wk "Git fetch")
    "g g" '(magit-status :wk "Magit status")
    "g i" '(magit-init :wk "Initialize git repo")
    "g l" '(magit-log-buffer-file :wk "Magit buffer log")
    "g r" '(vc-revert :wk "Git revert file")
    "g s" '(magit-stage-file :wk "Git stage file")
    "g t" '(git-timemachine :wk "Git time machine")
    "g u" '(magit-stage-file :wk "Git unstage file"))

 (db/leader-keys
    "h" '(:ignore t :wk "Help")
    "h a" '(counsel-apropos :wk "Apropos")
    "h b" '(describe-bindings :wk "Describe bindings")
    "h c" '(describe-char :wk "Describe character under cursor")
    "h d" '(:ignore t :wk "Emacs documentation")
    "h d a" '(about-emacs :wk "About Emacs")
    "h d d" '(view-emacs-debugging :wk "View Emacs debugging")
    "h d f" '(view-emacs-FAQ :wk "View Emacs FAQ")
    "h d m" '(info-emacs-manual :wk "The Emacs manual")
    "h d n" '(view-emacs-news :wk "View Emacs news")
    "h d o" '(describe-distribution :wk "How to obtain Emacs")
    "h d p" '(view-emacs-problems :wk "View Emacs problems")
    "h d t" '(view-emacs-todo :wk "View Emacs todo")
    "h d w" '(describe-no-warranty :wk "Describe no warranty")
    "h e" '(view-echo-area-messages :wk "View echo area messages")
    "h f" '(describe-function :wk "Describe function")
    "h F" '(describe-face :wk "Describe face")
    "h g" '(describe-gnu-project :wk "Describe GNU Project")
    "h i" '(info :wk "Info")
    "h I" '(describe-input-method :wk "Describe input method")
    "h k" '(describe-key :wk "Describe key")
    "h l" '(view-lossage :wk "Display recent keystrokes and the commands run")
    "h L" '(describe-language-environment :wk "Describe language environment")
    "h m" '(describe-mode :wk "Describe mode")
    "h r" '(:ignore t :wk "Reload")
    "h r r" '((lambda () (interactive)
                (load-file "~/.config/emacs/init.el")
                (ignore (use-package-process-queues)))
              :wk "Reload emacs config")
    "h t" '(load-theme :wk "Load theme")
    "h v" '(describe-variable :wk "Describe variable")
    "h w" '(where-is :wk "Prints keybinding for command if set")
    "h x" '(describe-command :wk "Display full documentation for command"))


  (db/leader-keys
    "m" '(:ignore t :wk "Org")
    "m a" '(org-agenda :wk "Org agenda")
    "m e" '(org-export-dispatch :wk "Org export dispatch")
    "m i" '(org-toggle-item :wk "Org toggle item")
    "m t" '(org-todo :wk "Org todo")
    "m B" '(org-babel-tangle :wk "Org babel tangle")
    "m T" '(org-todo-list :wk "Org todo list"))

  (db/leader-keys
    "m b" '(:ignore t :wk "Tables")
    "m b -" '(org-table-insert-hline :wk "Insert hline in table"))

  (db/leader-keys
    "m d" '(:ignore t :wk "Date/deadline")
    "m d t" '(org-time-stamp :wk "Org time stamp"))

  (db/leader-keys
    "o" '(:ignore t :wk "Open")
    "o d" '(dashboard-open :wk "Dashboard")
    "o e" '(elfeed :wk "Elfeed RSS")
    "o f" '(make-frame :wk "Open buffer in new frame")
    "o F" '(select-frame-by-name :wk "Select frame by name"))

  ;; projectile-command-map already has a ton of bindings
  ;; set for us, so no need to specify each individually.
  (db/leader-keys
    "p" '(:ignore t :wk "Projectile")
    "p p" '(projectile-command-map :wk "projectile map")
    "p a" '(my/projectile-add-project :which-key "add project")
    "p f" '(projectile-find-file :which-key "find file")
    "p d" '(projectile-find-dir :which-key "find directory")
    "p b" '(projectile-switch-to-buffer :which-key "switch buffer")
    "p c" '(projectile-compile-project :which-key "compile")
    "p k" '(projectile-kill-buffers :which-key "kill buffers")
    "p s" '(my/projectile-switch-project-with-completion :which-key "switch projects"))


  (db/leader-keys
    "s" '(:ignore t :wk "Search")
    "s d" '(dictionary-search :wk "Search dictionary")
    "s m" '(man :wk "Man pages")
    "s t" '(tldr :wk "Lookup TLDR docs for a command")
    "s w" '(woman :wk "Similar to man but doesn't require man"))

  (db/leader-keys
    "t" '(:ignore t :wk "Toggle")
    "t e" '(eshell-toggle :wk "Toggle eshell")
    "t f" '(flycheck-mode :wk "Toggle flycheck")
    "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
    "t n" '(neotree-toggle :wk "Toggle neotree file viewer")
    "t o" '(org-mode :wk "Toggle org mode")
    "t r" '(rainbow-mode :wk "Toggle rainbow mode")
    "t t" '(visual-line-mode :wk "Toggle truncated lines")
    "t v" '(vterm-toggle :wk "Toggle vterm"))

  (db/leader-keys
    "w" '(:ignore t :wk "Windows")
    ;; Window splits
    "w c" '(evil-window-delete :wk "Close window")
    "w n" '(evil-window-new :wk "New window")
    "w s" '(evil-window-split :wk "Horizontal split window")
    "w v" '(evil-window-vsplit :wk "Vertical split window")
    ;; Window motions
    "w h" '(evil-window-left :wk "Window left")
    "w j" '(evil-window-down :wk "Window down")
    "w k" '(evil-window-up :wk "Window up")
    "w l" '(evil-window-right :wk "Window right")
    "w w" '(evil-window-next :wk "Goto next window")
    ;; Move Windows
    "w H" '(buf-move-left :wk "Buffer move left")
    "w J" '(buf-move-down :wk "Buffer move down")
    "w K" '(buf-move-up :wk "Buffer move up")
    "w L" '(buf-move-right :wk "Buffer move right"))
)

(use-package git-timemachine
  :after git-timemachine
  :hook (evil-normalize-keymaps . git-timemachine-hook)
  :config
    (evil-define-key 'normal git-timemachine-mode-map (kbd "C-j") 'git-timemachine-show-previous-revision)
    (evil-define-key 'normal git-timemachine-mode-map (kbd "C-k") 'git-timemachine-show-next-revision)
)

(use-package transient)
(use-package magit :after transient)

;; Create a hydra menu for Eglot actions
(use-package hydra
  :ensure t
  :config
  (defhydra eglot-hydra (:color blue :hint nil)
    "
   ^Code Actions^          ^Go To^                ^Workspace^
  ^^^^^^^^-------------------------------------------------------
   _a_: Code actions       _d_: Definition        _p_: Find project
   _r_: Rename             _i_: Implementation    _s_: Sync project
   _f_: Format buffer      _t_: Type definition   _S_: Shutdown server
   _h_: Hover              _n_: Next error        _R_: Reconnect
   _o_: Organize imports   _N_: Previous error    _q_: Quit
  "
    ("a" my/eglot-actions)
    ("r" my/eglot-rename)
    ("f" eglot-format-buffer)
    ("h" eldoc)
    ("o" eglot-code-action-organize-imports)
    ("d" xref-find-definitions)
    ("i" eglot-find-implementation)
    ("t" eglot-find-typeDefinition)
    ("n" flymake-goto-next-error)
    ("N" flymake-goto-prev-error)
    ("p" project-find-file)
    ("s" eglot-reconnect)
    ("S" eglot-shutdown)
    ("R" eglot-reconnect)
    ("q" nil "quit" :color blue)))

(use-package hl-todo
  :hook ((org-mode . hl-todo-mode)
         (prog-mode . hl-todo-mode))
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        `(("TODO"       warning bold)
          ("FIXME"      error bold)
          ("HACK"       font-lock-constant-face bold)
          ("REVIEW"     font-lock-keyword-face bold)
          ("NOTE"       success bold)
          ("DEPRECATED" font-lock-doc-face bold))))

(use-package counsel
  :after ivy
  :diminish
  :config
    (counsel-mode)
    (setq ivy-initial-inputs-alist nil)) ;; removes starting ^ regex in M-x

(use-package counsel-projectile :ensure t)

(use-package ivy
  :bind
  ;; ivy-resume resumes the last Ivy-based completion.
  (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window))
  :diminish
  :custom
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  (when (executable-find "fd")
  (setq counsel-file-jump-args (split-string "-H -E .git -type f")))
  :config
  (ivy-mode))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :ensure t
  :init (ivy-rich-mode 1) ;; this gets us descriptions in M-x.
  :custom
  (ivy-virtual-abbreviate 'full
   ivy-rich-switch-buffer-align-virtual-buffer t
   ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))

(use-package php-mode)

;;mkdir ~/emacs-python-venvs
;;source ~/emacs-python-venvs/emacs-elpy-env/bin/activate
;;pip install jedi flake8 autopep8 black rope pytest
(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  :config
  ;; Set the Python interpreter
  (setq elpy-rpc-python-command "~/emacs-python-venvs/emacs-elpy-env/bin/python3")
  ;; Use the local Python environment for interactive shells
  (setq python-shell-interpreter "~/emacs-python-venvs/emacs-elpy-env/bin/python3"))

;; Optional: If you're using pyvenv to manage virtual environments in Emacs
(use-package pyvenv
  :ensure t
  :config
  ;; Activate the virtual environment you want to use
  (pyvenv-activate "~/emacs-python-venvs/emacs-elpy-env"))

(use-package csharp-mode
  :ensure nil  ; built-in package, no need to ensure
  :hook ((csharp-mode . eglot-ensure)
         (csharp-mode . (lambda ()
                          (setq indent-tabs-mode nil)
                          (setq c-basic-offset 4)
                          (setq tab-width 4)))
         (csharp-mode . tree-sitter-mode)
         (csharp-mode . company-mode)))

;; Load eglot (built-in for Emacs 29)
(use-package eglot
  :ensure nil  ; built-in for Emacs 29
  :config
  (add-to-list 'eglot-server-programs
               '(csharp-mode . ("dotnet" "/Users/danebalia/Sources/omnisharp/OmniSharp.dll" "-lsp" "--hostPID" "1" "--encoding" "utf-8" "--server-gc")))
  (setq eglot-connect-timeout 120)
  (setq eglot-sync-connect nil)
  (setq eglot-autoshutdown t)
  (setq eglot-send-changes-idle-time 0.5)
  (defun my/eglot-actions ()
    (interactive)
    (call-interactively #'eglot-code-actions))
  
  (defun my/eglot-rename ()
    (interactive)
    (call-interactively #'eglot-rename)))

;; Add these to csharp-mode-hook for automatic diagnostics
(add-hook 'csharp-mode-hook
          (lambda ()
            (my/eglot-capabilites)
            (my/company-diag)))

;; Enable tree-sitter for csharp-mode
(add-hook 'csharp-mode-hook #'tree-sitter-mode)

;; TypeScript mode
(use-package typescript-mode
  :ensure t
  :mode "\\.ts\\'"
  :hook ((typescript-mode . eglot-ensure)
         (typescript-mode . (lambda ()
                              (setq indent-tabs-mode nil)
                              (setq typescript-indent-level 2)
                              (setq tab-width 2)))
         (typescript-mode . tree-sitter-mode)
         (typescript-mode . company-mode))
  :config
  (require 'dap-node)
  (dap-node-setup))

;; Eglot configuration for TypeScript
(use-package eglot
  :ensure nil  ; built-in for Emacs 29
  :config
  (add-to-list 'eglot-server-programs
               '((typescript-mode) . ("typescript-language-server" "--stdio")))
  (setq eglot-connect-timeout 120)
  (setq eglot-sync-connect nil)
  (setq eglot-autoshutdown t)
  (setq eglot-send-changes-idle-time 0.5))

;; Optional: Prettier for formatting
(use-package prettier-js
  :ensure t
  :hook (typescript-mode . prettier-js-mode))

;; Optional: Add TypeScript debugging support
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-auto-configure-mode))

;; Key bindings (similar to your C# setup)
(add-hook 'typescript-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c a") 'eglot-code-actions)
            (local-set-key (kbd "C-c r") 'eglot-rename)
            (local-set-key (kbd "C-c f") 'eglot-format)))

;; Add diagnostics hooks (similar to your C# setup)
(add-hook 'typescript-mode-hook
          (lambda ()
            (when (fboundp 'my/eglot-capabilites)
              (my/eglot-capabilites))
            (when (fboundp 'my/company-diag)
              (my/company-diag))))

(global-set-key [escape] 'keyboard-escape-quit)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 35      ;; sets modeline height
        doom-modeline-bar-width 5    ;; sets right bar width
        doom-modeline-persp-name t   ;; adds perspective name to modeline
        doom-modeline-persp-icon t)) ;; adds folder icon next to persp name

(use-package neotree
  :config
  (setq neo-smart-open t
        neo-show-hidden-files t
        neo-window-width 55
        neo-window-fixed-size nil
        inhibit-compacting-font-caches t
        projectile-switch-project-action 'neotree-projectile-action)
        ;; truncate long file names in neotree
        (add-hook 'neo-after-create-hook
           #'(lambda (_)
               (with-current-buffer (get-buffer neo-buffer-name)
                 (setq truncate-lines t)
                 (setq word-wrap nil)
                 (make-local-variable 'auto-hscroll-mode)
                 (setq auto-hscroll-mode nil)))))

(use-package toc-org
    :commands toc-org-enable
    :init (add-hook 'org-mode-hook 'toc-org-enable))

(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(eval-after-load 'org-indent '(diminish 'org-indent-mode))

(custom-set-faces
 '(org-level-1 ((t (:inherit outline-1 :height 1.7))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.6))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.5))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.4))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.3))))
 '(org-level-6 ((t (:inherit outline-5 :height 1.2))))
 '(org-level-7 ((t (:inherit outline-5 :height 1.1)))))

(require 'org-tempo)

;; Performance optimizations
(setq gc-cons-threshold 100000000)  ; Increase garbage collection threshold
(setq read-process-output-max (* 1024 1024))  ; Increase read chunk size for process output

(use-package perspective
  :custom
  ;; NOTE! I have also set 'SCP =' to open the perspective menu.
  ;; I'm only setting the additional binding because setting it
  ;; helps suppress an annoying warning message.
  (persp-mode-prefix-key (kbd "C-c M-p"))
  :init
  (persp-mode)
  :config
  ;; Sets a file to write to when we save states
  (setq persp-state-default-file "~/.config/emacs/sessions"))

;; This will group buffers by persp-name in ibuffer.
(add-hook 'ibuffer-hook
          (lambda ()
            (persp-ibuffer-set-filter-groups)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))

;; Automatically save perspective states to file when Emacs exits.
(add-hook 'kill-emacs-hook #'persp-state-save)

(use-package projectile
  :init
  (setq projectile-project-search-path '("~/Sources"))  ; Set your default project search paths
  (setq projectile-switch-project-action #'neotree-projectile-action)
  (setq projectile-completion-system 'ivy)
  :config
  (projectile-mode 1))

 ;; Custom function to add a new project
  (defun my/projectile-add-project ()
    "Add a new project to Projectile."
    (interactive)
    (let ((project-dir (read-directory-name "Add project: ")))
      (projectile-add-known-project project-dir)
      (projectile-switch-project-by-name project-dir)))

  ;; Custom function to switch project with completion
  (defun my/projectile-switch-project-with-completion ()
    "Switch to a project using completion."
    (interactive)
    (projectile-switch-project))

(use-package rainbow-delimiters
  :hook ((emacs-lisp-mode . rainbow-delimiters-mode)
         (clojure-mode . rainbow-delimiters-mode)))

(use-package rainbow-mode
  :diminish
  :hook org-mode prog-mode)

(use-package rg
  :ensure t
  :config
  (require 'rg)
   (rg-enable-default-bindings))

(delete-selection-mode 1)    ;; You can select text and delete it by typing.
(electric-indent-mode -1)    ;; Turn off the weird indenting that Emacs does by default.
(electric-pair-mode 1)       ;; Turns on automatic parens pairing
;; The following prevents <> from auto-pairing when electric-pair-mode is on.
;; Otherwise, org-tempo is broken when you try to <s TAB...
(add-hook 'org-mode-hook (lambda ()
           (setq-local electric-pair-inhibit-predicate
                   `(lambda (c)
                  (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c))))))
(global-auto-revert-mode t)  ;; Automatically show changes if the file has changed
(global-display-line-numbers-mode 1) ;; Display line numbers
(global-visual-line-mode t)  ;; Enable truncated lines
(menu-bar-mode -1)           ;; Disable the menu bar
(scroll-bar-mode -1)         ;; Disable the scroll bar
(tool-bar-mode -1)           ;; Disable the tool bar
(setq org-edit-src-content-indentation 0) ;; Set src block automatic indent to 0 instead of 2.

(use-package eshell-toggle
  :custom
  (eshell-toggle-size-fraction 3)
  (eshell-toggle-use-projectile-root t)
  (eshell-toggle-run-command nil)
  (eshell-toggle-init-function #'eshell-toggle-init-ansi-term))

  (use-package eshell-syntax-highlighting
    :after esh-mode
    :config
    (eshell-syntax-highlighting-global-mode +1))

  ;; eshell-syntax-highlighting -- adds fish/zsh-like syntax highlighting.
  ;; eshell-rc-script -- your profile for eshell; like a bashrc for eshell.
  ;; eshell-aliases-file -- sets an aliases file for the eshell.

  (setq eshell-rc-script (concat user-emacs-directory "eshell/profile")
        eshell-aliases-file (concat user-emacs-directory "eshell/aliases")
        eshell-history-size 5000
        eshell-buffer-maximum-lines 5000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t
        eshell-destroy-buffer-when-process-dies t
        eshell-visual-commands'("bash" "fish" "htop" "ssh" "top" "zsh"))

(use-package vterm
:config
(setq shell-file-name "/bin/sh"
      vterm-max-scrollback 5000))

(use-package vterm-toggle
  :after vterm
  :config
  ;; When running programs in Vterm and in 'normal' mode, make sure that ESC
  ;; kills the program as it would in most standard terminal programs.
  (evil-define-key 'normal vterm-mode-map (kbd "<escape>") 'vterm--self-insert)
  (setq vterm-toggle-fullscreen-p nil)
  (setq vterm-toggle-scope 'project)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                     (let ((buffer (get-buffer buffer-or-name)))
                       (with-current-buffer buffer
                         (or (equal major-mode 'vterm-mode)
                             (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                  (display-buffer-reuse-window display-buffer-at-bottom)
                  ;;(display-buffer-reuse-window display-buffer-in-direction)
                  ;;display-buffer-in-direction/direction/dedicated is added in emacs27
                  ;;(direction . bottom)
                  ;;(dedicated . t) ;dedicated is supported in emacs27
                  (reusable-frames . visible)
                  (window-height . 0.4))))

(use-package sudo-edit)

(add-to-list 'custom-theme-load-path "~/.config/emacs/themes/")

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; Sets the default theme to load!!!
  (load-theme 'doom-one t)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package tldr)

;; Install and configure tree-sitter
(use-package tree-sitter
  :ensure t
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :ensure t
  :after tree-sitter)

(use-package which-key
  :init
    (which-key-mode 1)
  :diminish
  :config
  (setq which-key-idle-delay 0.3
        which-key-prefix-prefix "◉ "
        which-key-side-window-location 'bottom
	  which-key-sort-order #'which-key-key-order-alpha
	  which-key-allow-imprecise-window-fit nil
	  which-key-sort-uppercase-first nil
	  which-key-add-column-padding 1
	  which-key-max-display-columns nil
	  which-key-min-display-lines 6
	  which-key-side-window-slot -10
	  which-key-side-window-max-height 0.25
	  which-key-idle-delay 0.8
	  which-key-max-description-length 25
	  which-key-allow-imprecise-window-fit nil
	  which-key-separator " → " ))
