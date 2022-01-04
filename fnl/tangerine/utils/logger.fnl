; DEPENDS:
; (disable?) tangerine.utils.env
(local env (require :tangerine.utils.env))
(local log {})

;; -------------------- ;;
;;        Utils         ;;
;; -------------------- ;;
(lambda get-sep [arr]
  (if (> 5 (# arr)) " "
      :else "\n=> "))

(lambda print-array [arr title]
  (let [sep (get-sep arr)
        out (table.concat arr sep)]
       (print (.. title sep out))))

(lambda disable? [?verbose]
  (local env-verbose (env.get :compiler :verbose))
  (if (= true ?verbose)  false
      (= false ?verbose) true
      (= false env-verbose) true))

;; -------------------- ;;
;;     Compile Msgs     ;;
;; -------------------- ;;
(lambda log.compiled [files ?verbose]
  "prints compiled message for arr:'files'."
  (if (or (disable? ?verbose) (= 0 (# files)))
      (lua :return))
  (vim.cmd :redraw)
  (print-array files "COMPILED:"))

(lambda log.compiled-buffer [?verbose]
  (if (disable? ?verbose)
      (lua :return))
  (let [bufname (vim.fn.expand :%)
        qt "\""]
       (vim.cmd :redraw)
       (print (.. qt bufname qt " compiled" ))))

;; -------------------- ;;
;;      Eval Msgs       ;;
;; -------------------- ;;
(lambda serialize [tbl]
  (local out (-> (vim.inspect tbl)
                 (string.gsub "," "")
                 (string.gsub "= " "")
                 (string.gsub "(\n.-)%[\"(.-)\"%]" "%1%2")
                 (string.gsub "(\n.-)(%w)" "%1:%2")
                 (string.gsub "(\n.-)%{( .- )%}" "%1[%2]")))
  out)

(lambda log.value [val]
  (if (= :table (type val))
      (print ::return (serialize val))
      (not= val nil)
      (print ::return (vim.inspect val))))

:return log
