;; extends
; (
;  (function_call
;    (identifier) @require_call
;    (#match? @require_call "require")
;    )
;  (#set! conceal "")
; )

((function_call
    (identifier) @pairs
    (#match? @pairs "pairs")))

(function_declaration
  (identifier) @function_definition)

((function_declaration
    (dot_index_expression
      (identifier)
      (identifier) @function_definition)))

((assignment_statement
    (variable_list
      (identifier) @function_definition)
    (expression_list
      (function_definition))))

((assignment_statement
    (variable_list
      (dot_index_expression
        (identifier)
        (identifier) @function_definition))
    (expression_list
      (function_definition))))
