(use-modules (srfi srfi-19))

;;  100000000 nano seconds -> 0.1s
;;  200000000 nano seconds -> 0.2s
;;  300000000 nano seconds -> 0.3s
;;  400000000 nano seconds -> 0.4s
;;  500000000 nano seconds -> 0.5s
;; 1000000000 nano seconds -> 1s

;; This value is used for judge `clicking are continuously or not'
(define click-separation-threshold-nanosec 250000000)

(define (time-to-nanosecond time)
  (+ (* (time-second time)
        (expt 10 9))
     (time-nanosecond time)))

(define (emit-command k commands)
  (let ((cmd (assoc k commands)))
    (if cmd
        (eval (cdr cmd) (interaction-environment)))))

(define (multi-click-key key commands-normal . commands-long)
  (let ((time (current-time))
        (count 0))
    (unless (list? key)
      (set! key (list key)))
    (set! commands-long (if (null? commands-long)
                            #f
                            (begin
                              (set! commands-long (car commands-long))
                              (if (eq? #t commands-long)
                                  commands-normal
                                  commands-long))))
    (xbindkey-function key (lambda ()
                             (let ((prev-time time))
                               (set! time (current-time))
                               (if (> click-separation-threshold-nanosec (time-to-nanosecond (time-difference time prev-time)))
                                   (set! count (+ count 1))
                                   (set! count 1)))))
    (xbindkey-function (cons 'release key) (lambda ()
                                             (let ((diff-time (time-to-nanosecond (time-difference (current-time) time))))
                                               (if (> click-separation-threshold-nanosec diff-time)
                                                   (call-with-new-thread (let ((start-time-count count))
                                                                           (lambda ()
                                                                             (usleep (/ (- click-separation-threshold-nanosec diff-time) 1000))
                                                                             (if (= count start-time-count)
                                                                                 (emit-command start-time-count commands-normal)))))
                                                   (when commands-long
                                                     (emit-command count commands-long))))))))

(multi-click-key 'b:8 '((1 . (run-command "xte 'key XF86AudioPlay'"))
                         (2 . (run-command "xte 'key XF86AudioPrev'"))
                         (3 . (run-command ""))
                         (4 . (run-command "")))
                 '((1 . (run-command "xte 'keydown Control_L' 'key w' 'keyup Control_L'"))
                   (2 . (run-command ""))
                   (3 . (run-command ""))))

(multi-click-key 'b:9 '((1 . (run-command "xte 'key XF86AudioNext'"))
                         (2 . (run-command "jumpapp chrome"))
                         (3 . (run-command "jumpapp code"))
                         (4 . (run-command "")))
                 '((1 . (run-command "xte 'keydown Control_L' 'keydown Shift_L' 'key t' 'keyup Control_L' 'keyup Shift_L'"))
                   (2 . (run-command ""))
                   (3 . (run-command ""))))


(xbindkey '("m:0x10" "c:248") "xte 'keydown Control_L' 'key w' 'keyup Control_L'")
(xbindkey '(control b:8) "amixer set Master 10%-")
(xbindkey '(control b:9) "amixer set Master 10%+")

;; second alist can define long hold click maps.
;; `long hold' means `last one click holds longer than click-separation-threshold-nanosec time'

