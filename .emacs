;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; .emacs 
;;
;; based on Jean's Hennebert's version
;; Jan Cernocky
;;
;; last modifications:
;;   24/9/98 - czechization
;;   Tue May 11 09:28:30 CEST 1999 -- adding white for comments
;; 
;;   Tue Aug 17 19:03:54 CEST 1999
;;      czech input from clipboard
;;
;; Mon Apr 10 16:12:46 CEST 2000
;;   adding matlab mode, found matlab.el on:
;;   ftp://ftp.mathworks.com/pub/contrib/emacs_add_ons/matlab.el
;;   following the instructions in that file. 
;;
;; same day: changing re-coloring from hilit19 to font-lock.
;;
;; Wed Mar 21 15:27:14 PST 2001
;;  turn off the verification on saving Matlab files (very boring, when a 
;;  text file contains just some Matlab commands, and m-mode thinks everything
;;  is Matlab ...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-font-lock-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(send-mail-function (quote smtpmail-send-it))
 '(smtpmail-smtp-server "kazi.fit.vutbr.cz")
 '(smtpmail-smtp-service 25))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((((class color) (background dark)) (:foreground "White")))))


;;;;; Set utf system
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; ------ Highlighting - no more needed !  --------
;;      (setq hilit-mode-enable-list  '(not text-mode)
;;	hilit-background-mode   'dark
;;	hilit-inhibit-hooks     nil
;;	hilit-inhibit-rebinding nil)
;;    
;;      (require 'hilit19)
;; (hilit-translate comment 'white)

(line-number-mode t)                 ;; Shows current line number in status bar
(setq next-line-add-newlines nil)    ;; Avoid odd behaviour of next-line
(setq scroll-step 1)                 ;; This is slower, but smoother
(setq delete-auto-save-files t)

(server-start)  ;; allows this emacs to be server for client processes

;; Term bindings
(global-set-key "\eOA"        'previous-line)
(global-set-key "\eOC"        'forward-char)
(global-set-key "\eOB"        'next-line)
(global-set-key "\eOD"        'backward-char)
(global-set-key "\eOM"        'scroll-up)
(global-set-key "\eOk"        'scroll-down)

;; C mode definitions
(fmakunbound 'c-mode)
(makunbound 'c-mode-map)
(fmakunbound 'c++-mode)
(makunbound 'c++-mode-map)
(makunbound 'c-style-alist)
(autoload 'c++-mode "cc-mode" "C++ Editing Mode" t)
(autoload 'c-mode   "cc-mode" "C Editing Mode" t)
(autoload 'matlab-mode "matlab" "Enter Matlab mode." t)
(setq matlab-verify-on-save-flag nil) ; turn off auto-verify on save
(defun my-matlab-mode-hook ()
     (setq fill-column 256))           ; where auto-fill should wrap
   (add-hook 'matlab-mode-hook 'my-matlab-mode-hook)
   (defun my-matlab-shell-mode-hook ()
      '())
   (add-hook 'matlab-shell-mode-hook 'my-matlab-shell-mode-hook)  
(setq auto-mode-alist
  (append '(("\\.C$"  . c++-mode)
            ("\\.cc$" . c++-mode)
	    ("\\.cxx$". c++-mode)
            ("\\.c$"  . c-mode)   ; to edit C code
            ("\\.h$"  . c-mode)   ; to edit C code
	    ("\\.tex" . latex-mode)  ; jan added, was plain Tex, quite terrible
	    ("\\.m" . matlab-mode) 
           ) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive Matlab mode." t)

;; jan wants GNU style, but indentation 3
(add-hook 'c-mode-hook
	  (function (lambda ()
	      (setq c-indent-level                 3
		    c-argdecl-indent               5
		    c-brace-offset                 0
		    c-continued-brace-offset       0
		    c-label-offset                -3
		    c-continued-statement-offset   3 
		    c-auto-newline f))))


;; -------------------------  Misc hook functions  -------------------------

;; Force auto-fill-mode in text-mode and Tex Mode
(add-hook 'mail-mode-hook 
	  (function (lambda ()
		      (auto-fill-mode 1))))
(add-hook 'tex-mode-hook
	  (function (lambda ()
		      (auto-fill-mode 1))))

;;
;; Window system
;;
(if window-system 
    (progn

      ;; Some new addition
      (transient-mark-mode 1)

      ;; Colors, faces and fonts
      (set-cursor-color      "red")
      (set-mouse-color       "lightgreen")
      (set-foreground-color  "wheat")       ;; was grey85
      (set-background-color  "black")

      ;; "bold" face definition
(set-face-foreground   'bold        "cornsilk")
(set-face-background   'bold        "darkslategrey")
(set-face-foreground   'bold-italic "yellow")
(set-face-background   'bold-italic "darkslategrey")
(set-face-foreground   'highlight   "grey85")
(set-face-background   'highlight   "darkslateblue")
(set-face-foreground   'underline   "skyblue")
(set-face-background   'underline   "darkslategrey")
(set-face-underline-p  'underline   nil)
(set-face-foreground   'region      "grey95")
(set-face-background   'region      "grey40")
      
      ;; X Bindings
      (global-set-key [next]        'scroll-up)
      (global-set-key [prior]       'scroll-down)
      (global-set-key [home]        'beginning-of-line)
      (global-set-key [end]         'end-of-line)
      (global-set-key [C-prior]     'beginning-of-buffer)
      (global-set-key [C-next]      'end-of-buffer)
      (global-set-key [kp-enter]    'scroll-up)
      (global-set-key [kp-add]      'scroll-down)
      (global-set-key [C-7]         'undo)
      (global-set-key [C-delete]    'undo)
      (global-set-key [C-backspace] 'undo)
      (global-set-key [f5]          'delete-other-windows)
      (global-set-key [f6]          'other-window)

      ;; Paren enlightning
      (load-library "paren")

;;  Draggable modeline  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key [mode-line down-mouse-1] 'mldrag-drag-mode-line)
(global-set-key [vertical-line down-mouse-1] 'mldrag-drag-vertical-line)
(global-set-key [vertical-scroll-bar S-down-mouse-1]
                'mldrag-drag-vertical-line)
(require 'mldrag)
      
;; Jan's Additional bindings -- let the first two ones commented out.
;; requires Jan's .Xmodmap file
;;      (global-set-key "\?" 'help-command)
;;      (global-set-key "\C-h" 'delete-backward-char)
      (global-set-key [delete]      'delete-char)))
      
;; jan - does not have at esiee. require 'tex-site)

;;;;;;;;;;;;;;;;;;;;;; jan ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; french letters ;;;
  (global-set-key [f9]         "\\'e")
  (global-set-key [f10]         "\\`e")
  (global-set-key [f11]         "\\^e")
  (global-set-key [f12]         "\\`a")

;  (global-set-key [S-kp-f1]         "\\'{E}")   ;this is for S-f9
;  (global-set-key [S-kp-f2]         "\\`{E}")   ;this is for S-f10
;  (global-set-key [S-kp-f3]         "\\^{E}")   ;this is for S-f11
;  (global-set-key [S-kp-f4]         "\\`{A}")   ;this is for S-f12

;;; for the czech (copied /usr/doc/emacs-20.2/priklad_.emacs), 

;;(register-input-method
;; "latin-2-prefix" "Latin-2" 'quail-use-package
;; "2>" "Latin-2 characters input method with prefix modifiers"
;; "quail/latin-pre")


;; RH 6.1 
;;(load "/usr/share/emacs/20.7/leim/quail/czech.el")
;; RH 7 
;;(load "/usr/share/emacs/20.7/leim/quail/czech.el")
;;(load "/u/honza/BORDEL/czech")
;;(require 'hack-quail)
;;(require 'czech)
;;(load "/usr/bin/czech.el")
;;(require 'hack-quail)
;;(require 'czech)
(set-language-environment "czech")
;;(setq default-input-method "czech-querty")
(setq default-input-method "czech-prog-3")
;;(require 'czech-calendar) -- jan no
;;(require 'cz-print)       ;;-- jan no

;; vdiff
;;(load "/mnt/matylda3/karafiat/BABEL/GIT/emacs-vdiff/vdiff.el")

(if window-system
      (setq clipboard-coding-system 'latin-2)
    (set-terminal-coding-system 'latin-2))
(setq process-coding-system-alist '((".*" . iso-8859-2)))

(setq dos-codepage 852)
(setq default-enable-multibyte-characters t)
;;;;; od Vaska pro psani prehlasek - budou jako aouy s hackem !
;;;;; nejak to nechodi ...

;;(global-set-key "+a" '(lambda() (interactive) (insert 228)));
;;(global-set-key "+A" '(lambda() (interactive) (insert 196)));
;;;; (global-set-key "+f" '(lambda() (interactive) (insert 235)));
;;;; (global-set-key "+F" '(lambda() (interactive) (insert 203)));
;;(global-set-key "+o" '(lambda() (interactive) (insert 246)));
;;(global-set-key "+O" '(lambda() (interactive) (insert 214)));
;;(global-set-key "+y" '(lambda() (interactive) (insert 252)));
;;(global-set-key "+Y" '(lambda() (interactive) (insert 220)));



(put 'upcase-region 'disabled nil)


;; My section
(global-set-key (kbd "C-x C-f") 'ffap)
(normal-erase-is-backspace-mode 0)
