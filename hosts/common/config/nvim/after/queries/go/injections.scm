; extends

; Comment-based: highlights string as SQL when preceded by a "//sql" comment
(
  (comment) @_comment
  .
  (short_var_declaration
    right: (expression_list
      (raw_string_literal
        (raw_string_literal_content) @injection.content)))
  (#match? @_comment "sql")
  (#set! injection.language "sql")
)

(
  (comment) @_comment
  .
  (short_var_declaration
    right: (expression_list
      (interpreted_string_literal
        (interpreted_string_literal_content) @injection.content)))
  (#match? @_comment "sql")
  (#set! injection.language "sql")
)

(
  (comment) @_comment
  .
  (assignment_statement
    right: (expression_list
      (raw_string_literal
        (raw_string_literal_content) @injection.content)))
  (#match? @_comment "sql")
  (#set! injection.language "sql")
)

(
  (comment) @_comment
  .
  (assignment_statement
    right: (expression_list
      (interpreted_string_literal
        (interpreted_string_literal_content) @injection.content)))
  (#match? @_comment "sql")
  (#set! injection.language "sql")
)

(
  (comment) @_comment
  .
  (var_declaration
    (var_spec
      value: (expression_list
        (raw_string_literal
          (raw_string_literal_content) @injection.content))))
  (#match? @_comment "sql")
  (#set! injection.language "sql")
)

(
  (comment) @_comment
  .
  (const_declaration
    (const_spec
      value: (expression_list
        (raw_string_literal
          (raw_string_literal_content) @injection.content))))
  (#match? @_comment "sql")
  (#set! injection.language "sql")
)

; String content containing "--sql" marker
(
  (raw_string_literal
    (raw_string_literal_content) @injection.content)
  (#match? @injection.content "--sql")
  (#set! injection.language "sql")
)

(
  (interpreted_string_literal
    (interpreted_string_literal_content) @injection.content)
  (#match? @injection.content "--sql")
  (#set! injection.language "sql")
)

; Auto-detect: strings containing SQL keywords
(
  (raw_string_literal
    (raw_string_literal_content) @injection.content)
  (#match? @injection.content "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete|CREATE|create|ALTER|alter|DROP|drop|WITH|with|MERGE|merge).+(FROM|from|INTO|into|VALUES|values|SET|set|TABLE|table|AS|as)")
  (#set! injection.language "sql")
)

(
  (interpreted_string_literal
    (interpreted_string_literal_content) @injection.content)
  (#match? @injection.content "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete|CREATE|create|ALTER|alter|DROP|drop|WITH|with|MERGE|merge).+(FROM|from|INTO|into|VALUES|values|SET|set|TABLE|table|AS|as)")
  (#set! injection.language "sql")
)

; Match SQL in common database function calls
((call_expression
  (selector_expression
    field: (field_identifier) @_field)
  (argument_list
    (raw_string_literal
      (raw_string_literal_content) @injection.content)))
  (#any-of? @_field "Exec" "ExecContext" "Get" "GetContext" "Select" "SelectContext"
    "Query" "QueryContext" "QueryRow" "QueryRowContext" "QueryRowx" "QueryRowxContext"
    "Queryx" "QueryxContext" "NamedExec" "NamedExecContext" "MustExec" "MustExecContext"
    "Prepare" "PrepareContext" "Preparex" "PreparexContext" "Rebind")
  (#set! injection.language "sql"))

((call_expression
  (selector_expression
    field: (field_identifier) @_field)
  (argument_list
    (interpreted_string_literal
      (interpreted_string_literal_content) @injection.content)))
  (#any-of? @_field "Exec" "ExecContext" "Get" "GetContext" "Select" "SelectContext"
    "Query" "QueryContext" "QueryRow" "QueryRowContext" "QueryRowx" "QueryRowxContext"
    "Queryx" "QueryxContext" "NamedExec" "NamedExecContext" "MustExec" "MustExecContext"
    "Prepare" "PrepareContext" "Preparex" "PreparexContext" "Rebind")
  (#set! injection.language "sql"))
