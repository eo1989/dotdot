; extends
(code_fence_content) @block.inner

(fenced_code_block (code_fence_content) @block.inner) @block.outer

(paragraph) @function.outer @function.inner

; [
;   (paragraph)
;   (list)
; ] @code_cell.outer
