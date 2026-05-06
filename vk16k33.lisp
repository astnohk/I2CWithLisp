(defpackage :i2c-vk16k33
    (:use :cl)
    (:export
        :TURN_ON_SYSTEM
        :BLINKING_OFF
        :BLINKING_2HZ
        :BLINKING_1HZ
        :BLINKING_0_5HZ
        :DISPLAY_OFF
        :DISPLAY_ON
        :DIG_1A
        :DIG_1B
        :DIG_2A
        :DIG_2B
        :DIG_3A
        :DIG_3B
        :DIG_4A
        :DIG_4B
        :system-setup
        :display-setup
        :set-display-memory
        :set-digit
        :send-display-memory))
(in-package :i2c-vk16k33)

(require :i2c-dev)

;
; Generic Functions
;
(defun get-elapsed-time () (/ (get-internal-real-time) internal-time-units-per-second))
(defun zeros (N) (loop for i from 0 below N collect 0))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VK16K33 Constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defconstant DEVADDR #x70)

(defconstant ADDR_DISPLAY_MEMORY #x00)

;; System setup
(defconstant TURN_ON_SYSTEM #x01)

;; Display setup
(defconstant BLINKING_OFF #x00)
(defconstant BLINKING_2HZ #x02)
(defconstant BLINKING_1HZ #x04)
(defconstant BLINKING_0_5HZ #x06)
(defconstant DISPLAY_OFF #x00)
(defconstant DISPLAY_ON #x01)

;; Patterns
(defconstant DIG_1A #x01)
(defconstant DIG_1B #x10)
(defconstant DIG_2A #x02)
(defconstant DIG_2B #x20)
(defconstant DIG_3A #x04)
(defconstant DIG_3B #x40)
(defconstant DIG_4A #x08)
(defconstant DIG_4B #x80)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Buffers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defparameter *rbuf* (i2c-dev:create-i2c-buffer 16))
(defparameter *wbuf* (i2c-dev:create-i2c-buffer 17))
(defparameter *display-memory* (make-array 16 :initial-element 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun system-setup (start)
    (if start
        (setf (i2c-dev:i2c-buffer-aref *wbuf* 0) #x21)
        (setf (i2c-dev:i2c-buffer-aref *wbuf* 0) #x20))
    (i2c-dev:i2c-write DEVADDR *wbuf* 1))

(defun display-setup (blinking display)
    (setf (i2c-dev:i2c-buffer-aref *wbuf* 0)
          (logior #x80
                  blinking
                  display))
    (i2c-dev:i2c-write DEVADDR *wbuf* 1))

(defun set-display-memory (ind val)
    (setf (aref *display-memory* ind) val))

(defun set-digit (digit cols)
    (let ((digit-filter (logand #xff (lognot digit))))
        (loop for i from 0 below 7 do
            (setf (aref *display-memory* (* 2 i))
                  (logior (logand (aref *display-memory* (* 2 i))
                                  digit-filter)
                          (if (> (logand #x01 (ash cols (- 0 i)))
                                 0)
                              digit 0))))))

(defun send-display-memory ()
    (setf (i2c-dev:i2c-buffer-aref *wbuf* 0) ADDR_DISPLAY_MEMORY)
    (loop for i from 0 below 16 do
        (setf (i2c-dev:i2c-buffer-aref *wbuf* (+ 1 i)) (aref *display-memory* i)))
    (i2c-dev:i2c-write DEVADDR *wbuf* 17))
