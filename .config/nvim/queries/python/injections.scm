;; extends

;; pydocs

; function/method docstring
; inject RestructuredText
(function_definition
  body: (block .
    (expression_statement
      (string
       (string_content) @injection.content (#set! injection.language "rst")
       )
      )
    )
  )

; class docstring
; inject RestructuredText
(class_definition
  body: (block .
    (expression_statement
      (string
       (string_content) @injection.content (#set! injection.language "rst")
       )
      )
    )
  )
