;;; core-spacemacs-buffer.el --- Spacemacs Core File
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Fabien Dubosson <fabien.dubosson@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(require 'widget)

(defconst spaceconf-buffer-name "*spaceconf*"
  "The name of the spaceconf buffer.")

(defvar spaceconf-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map [tab] 'widget-forward)
    (define-key map (kbd "C-i") 'widget-forward)
    (define-key map (kbd "C-n") 'widget-forward)

    (define-key map [backtab] 'widget-backward)
    (define-key map (kbd "C-p") 'widget-backward)

    (define-key map (kbd "RET") 'widget-button-press)
    (define-key map [down-mouse-1] 'widget-button-click)

    (define-key map "q" 'quit-window)
    map)
  "Keymap for spaceconf buffer mode.")

(with-eval-after-load 'evil
  (evil-make-overriding-map spaceconf-mode-map 'motion))

(define-derived-mode spaceconf-mode fundamental-mode "Spaceconf"
  "Spaceconf major mode for startup screen."
  :group 'spaceconf
  :syntax-table nil
  :abbrev-table nil
  (setq buffer-read-only t
        truncate-lines t)
  (page-break-lines-mode)
  ;; needed to make tab work correctly in terminal
  (evil-define-key 'motion spaceconf-mode-map (kbd "C-i") 'widget-forward)
  ;; motion state since this is a special mode
  (unless (eq dotspacemacs-editing-style 'emacs)
    (evil-set-initial-state 'spaceconf-buffer-mode 'motion)))

(defun spaceconf/enable ()
  (widget-insert "Checklist is used for multiple choices from a list.\n")
  (widget-create 'radio-button-choice
                 :value "One"
                 :notify (lambda (wid &rest ignore)
                           (message "You select %S %s"
                                    (widget-type wid)
                                    (widget-value wid)))
                 '(item "One")
                 '(item "Two")
                 '(item "Three"))
  (widget-create 'checklist
                 :notify (lambda (wid &rest ignore)
                           (message "The value is %S" (widget-value wid)))
                 '(item "one")
                 '(item "two")
                 '(item "three")))

(switch-to-buffer (get-buffer-create spaceconf-buffer-name))
(spaceconf-mode)
(spaceconf/enable)
