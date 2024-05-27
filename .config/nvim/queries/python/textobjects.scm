;; extends

; key/value
; (pair
;   key: (_) @key.inner
;   value: (_) @value.inner
; ) @key.outer @value.outer

; swappable items
(_) @node
(argument_list (_) @swappable)
(parameters (_) @swappable)
(list (_) @swappable)
