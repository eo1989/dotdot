;; extends
; (code_fence_content) @markup.row.block

; (
;  (fenced_code_block_delimiter)
;   (@conceal
;     (#set! conceal "")
;     (#set! priority 90))
;   @markup.raw.block
;
;  )

(list_item [
  (list_marker_plus)
  (list_marker_minus)
  (list_marker_star)
  (list_marker_dot)
  (list_marker_parenthesis)
] @conceal [
    (task_list_marker_checked)
    (task_list_marker_unchecked)
](#set! conceal ""))

((task_list_marker_checked) @conceal (#set! conceal "󰱒 ") )
((task_list_marker_unchecked)@conceal (#set! conceal " ") )
