;;; skk-leim.el --- SKK related code for LEIM
;; Copyright (C) 1997, 1999, 2000
;; Murata Shuuichirou <mrt@astec.co.jp>
;;
;; Author: Murata Shuuichirou <mrt@mickey.ai.kyutech.ac.jp>
;; Maintainer: SKK Development Team <skk@ring.gr.jp>
;; Version: $Id: skk-leim.el,v 1.7 2000/10/30 22:10:17 minakaji Exp $
;; Keywords: japanese
;; Last Modified: $Date: 2000/10/30 22:10:17 $

;; This file is part of Daredevil SKK.

;; Daredevil SKK is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either versions 2, or (at your option)
;; any later version.

;; Daredevil SKK is distributed in the hope that it will be useful
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with Daredevil SKK, see the file COPYING.  If not, write to the Free
;; Software Foundation Inc., 59 Temple Place - Suite 330, Boston,
;; MA 02111-1307, USA.

;;; Code:
(eval-when-compile (require 'skk-macs) (require 'skk-vars))

;;;###autoload
(defun skk-activate (&optional name)
  (setq inactivate-current-input-method-function 'skk-inactivate)
  (skk-mode 1)
  (if (eq (selected-window) (minibuffer-window))
      (add-hook 'minibuffer-exit-hook 'skk-leim-exit-from-minibuffer)))

;;;###autoload
(defun skk-auto-fill-activate (&optional name)
  (setq inactivate-current-input-method-function 'skk-auto-fill-inactivate)
  (skk-auto-fill-mode 1)
  (if (eq (selected-window) (minibuffer-window))
      (add-hook 'minibuffer-exit-hook 'skk-leim-exit-from-minibuffer)))

;;;###autoload
(defun skk-inactivate ()
  (skk-mode -1))

;;;###autoload
(defun skk-auto-fill-inactivate ()
  (skk-auto-fill-mode -1))

(defun skk-leim-exit-from-minibuffer ()
  (inactivate-input-method)
  (if (<= (minibuffer-depth) 1)
      (remove-hook 'minibuffer-exit-hook 'skk-leim-exit-from-minibuffer)))

;;;###autoload
(register-input-method
 "japanese-skk" "Japanese"
 'skk-activate ""
 "Simple Kana to Kanji conversion program")

;;;###autoload
(register-input-method
 "japanese-skk-auto-fill" "Japanese"
 'skk-auto-fill-activate ""
 "Simple Kana to Kanji conversion program with auto-fill")

;; The following two functions are from egg-util.el.

;;;###autoload
(defun locate-libraries (library &optional nosuffix path interactive-call)
  (let ((lpath (or path load-path))
	(result nil))
    (while lpath
      (let ((path (locate-library library nosuffix lpath interactive-call)))
	(if path
	    (progn
	      (setq lpath (cdr-safe 
			   (member (directory-file-name (file-name-directory path))
				   lpath))
		    result (cons path result)))
	  (progn
	    (setq lpath nil
		  result (reverse result))))))
    result))

;;;###autoload
(defun load-libraries (library &optional path)
  (let ((files (locate-libraries library nil (or path load-path) nil)))
    (while files
      (load-file (car files))
      (setq files (cdr files)))))

(require 'product)
(product-provide (provide 'skk-leim) (require 'skk-version))

;;;###autoload
(when (and (featurep 'xemacs)
	   (file-exists-p
	    (expand-file-name "auto-autoloads.el"
			      (file-name-directory (locate-library "skk"))))
	   (not (featurep 'skk-leim)))
  ;; auto-autoloads.el $BFb!#(B
  (require 'skk-setup))

;;; skk-leim.el ends here
