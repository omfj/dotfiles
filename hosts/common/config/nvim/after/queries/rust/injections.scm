; extends

; Comment-based: highlights string as SQL when preceded by a "//sql" comment
(
  (line_comment) @_comment
  .
  (let_declaration
    value: (string_literal
      (string_content) @injection.content))
  (#match? @_comment "sql")
  (#set! injection.language "sql")
)

(
  (line_comment) @_comment
  .
  (let_declaration
    value: (raw_string_literal) @injection.content)
  (#match? @_comment "sql")
  (#offset! @injection.content 0 3 0 -2)
  (#set! injection.language "sql")
)

; String content containing "--sql" marker
(
  (string_literal
    (string_content) @injection.content)
  (#match? @injection.content "--sql")
  (#set! injection.language "sql")
)

(
  (raw_string_literal) @injection.content
  (#match? @injection.content "--sql")
  (#offset! @injection.content 0 3 0 -2)
  (#set! injection.language "sql")
)

; Auto-detect: strings containing SQL keywords
(
  (string_literal
    (string_content) @injection.content)
  (#match? @injection.content "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete|CREATE|create|ALTER|alter|DROP|drop|WITH|with|MERGE|merge).+(FROM|from|INTO|into|VALUES|values|SET|set|TABLE|table|AS|as)")
  (#set! injection.language "sql")
)

(
  (raw_string_literal) @injection.content
  (#match? @injection.content "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete|CREATE|create|ALTER|alter|DROP|drop|WITH|with|MERGE|merge).+(FROM|from|INTO|into|VALUES|values|SET|set|TABLE|table|AS|as)")
  (#offset! @injection.content 0 3 0 -2)
  (#set! injection.language "sql")
)

; Match sqlx macros: sqlx::query!(), sqlx::query_as!(), query!(), etc.
(macro_invocation
  macro: [
    (scoped_identifier name: (_) @_macro_name)
    (identifier) @_macro_name
  ]
  (token_tree (raw_string_literal) @injection.content)
  (#match? @_macro_name "query")
  (#offset! @injection.content 0 3 0 -2)
  (#set! injection.language "sql")
  (#set! injection.include-children))

(macro_invocation
  macro: [
    (scoped_identifier name: (_) @_macro_name)
    (identifier) @_macro_name
  ]
  (token_tree
    (string_literal
      (string_content) @injection.content))
  (#match? @_macro_name "query")
  (#set! injection.language "sql")
  (#set! injection.include-children))
