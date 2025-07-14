; extends
(code_fence_content) @code_cell.inner

(fenced_code_block (code_fence_content) @code_cell.inner) @code_cell.outer

(paragraph) @function.outer @function.inner

; [
;   (paragraph)
;   (list)
; ] @code_cell.outer
