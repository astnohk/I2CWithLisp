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
        :DIG_1
        :DIG_2
        :DIG_3
        :DIG_4
        :DIM_1_16_DUTY
        :DIM_2_16_DUTY
        :DIM_3_16_DUTY
        :DIM_4_16_DUTY
        :DIM_5_16_DUTY
        :DIM_6_16_DUTY
        :DIM_7_16_DUTY
        :DIM_8_16_DUTY
        :DIM_9_16_DUTY
        :DIM_10_16_DUTY
        :DIM_11_16_DUTY
        :DIM_12_16_DUTY
        :DIM_13_16_DUTY
        :DIM_14_16_DUTY
        :DIM_15_16_DUTY
        :DIM_16_16_DUTY
        :SEGMENT_NULL
        :SEGMENT_MINUS
        :SEGMENT_0
        :SEGMENT_1
        :SEGMENT_2
        :SEGMENT_3
        :SEGMENT_4
        :SEGMENT_5
        :SEGMENT_6
        :SEGMENT_7
        :SEGMENT_8
        :SEGMENT_9
        :system-setup
        :display-setup
        :set-dimming
        :set-display-memory
        :set-digits
        :set-digits-number
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

;; Dimming
(defconstant DIM_1_16_DUTY #x00)
(defconstant DIM_2_16_DUTY #x01)
(defconstant DIM_3_16_DUTY #x02)
(defconstant DIM_4_16_DUTY #x03)
(defconstant DIM_5_16_DUTY #x04)
(defconstant DIM_6_16_DUTY #x05)
(defconstant DIM_7_16_DUTY #x06)
(defconstant DIM_8_16_DUTY #x07)
(defconstant DIM_9_16_DUTY #x08)
(defconstant DIM_10_16_DUTY #x09)
(defconstant DIM_11_16_DUTY #x0a)
(defconstant DIM_12_16_DUTY #x0b)
(defconstant DIM_13_16_DUTY #x0c)
(defconstant DIM_14_16_DUTY #x0d)
(defconstant DIM_15_16_DUTY #x0e)
(defconstant DIM_16_16_DUTY #x0f)

;; Patterns
(defconstant DIG_1 #x1001)
(defconstant DIG_2 #x2002)
(defconstant DIG_3 #x4004)
(defconstant DIG_4 #x8008)

(defconstant SEGMENT_NULL #x0000)
(defconstant SEGMENT_MINUS #x0140)
(defconstant SEGMENT_0 #x003f)
(defconstant SEGMENT_1 #x0006)
(defconstant SEGMENT_2 #x015b)
(defconstant SEGMENT_3 #x014f)
(defconstant SEGMENT_4 #x0166)
(defconstant SEGMENT_5 #x016d)
(defconstant SEGMENT_6 #x017d)
(defconstant SEGMENT_7 #x0007)
(defconstant SEGMENT_8 #x01ff)
(defconstant SEGMENT_9 #x016f)

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

(defun set-dimming (dim)
    (setf (i2c-dev:i2c-buffer-aref *wbuf* 0)
          (logior #xe0
                  dim))
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

(defun set-digits (digits cols)
    (set-digit (logand #xff digits) (logand #xff cols))
    (set-digit (logand #xff (ash digits -8)) (logand #xff (ash cols -8))))

(defun set-digits-number (digits num)
    (cond ((= num 0) (set-digits digits SEGMENT_0))
          ((= num 1) (set-digits digits SEGMENT_1))
          ((= num 2) (set-digits digits SEGMENT_2))
          ((= num 3) (set-digits digits SEGMENT_3))
          ((= num 4) (set-digits digits SEGMENT_4))
          ((= num 5) (set-digits digits SEGMENT_5))
          ((= num 6) (set-digits digits SEGMENT_6))
          ((= num 7) (set-digits digits SEGMENT_7))
          ((= num 8) (set-digits digits SEGMENT_8))
          ((= num 9) (set-digits digits SEGMENT_9))
          (5 (set-digits digits SEGMENT_0))))

(defun send-display-memory ()
    (setf (i2c-dev:i2c-buffer-aref *wbuf* 0) ADDR_DISPLAY_MEMORY)
    (loop for i from 0 below 16 do
        (setf (i2c-dev:i2c-buffer-aref *wbuf* (+ 1 i)) (aref *display-memory* i)))
    (i2c-dev:i2c-write DEVADDR *wbuf* 17))
