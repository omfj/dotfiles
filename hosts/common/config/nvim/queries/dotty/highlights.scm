; Keywords
"link"   @keyword
"do"     @keyword
"if"     @keyword
"else"   @keyword
"print"  @keyword

; Operators
"to"     @keyword.operator
"is"     @keyword.operator
"not"    @keyword.operator
"or"     @keyword.operator
"and"    @keyword.operator
"="      @operator

; Builtin expressions
"env"    @function.builtin
"test"   @function.builtin
"exists" @function.builtin

; Special global variables
((identifier) @variable.builtin
  (#any-of? @variable.builtin "os" "hostname" "profile"))

; Assignment name
(assignment name: (identifier) @variable)

; Identifiers used as values (e.g. in conditions)
(identifier) @variable

; Strings
(string_content)        @string
(string_single_content) @string
[
  "\""
  "'"
] @string.delimiter

; Variable interpolation inside strings
(interpolation
  "$"         @punctuation.special
  (identifier) @variable)

; Comments
(comment) @comment

; Punctuation
"{" @punctuation.bracket
"}" @punctuation.bracket
