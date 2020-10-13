
((function_item 
    name: (identifier) @name.func) @func)

((function_item 
  name: (identifier) @name.method
  parameters: (parameters 
                (self_parameter))) @method)

; Types
((struct_item
  name: (type_identifier) @name.type) @type)

((constrained_type_parameter 
  left: (type_identifier) @name.type) @type) ; the P in  remove_file<P: AsRef<Path>>(path: P)

((enum_item
  name: (type_identifier) @name.type) @type)

; Scopes
[
 (block)
; (function_item)
; (closure_expression)
; (while_expression)
; (for_expression)
; (loop_expression)
; (if_expression)
; (if_let_expression)
; (match_expression)
; (match_arm)
;
; (struct_item)
; (enum_item)
; (impl_item)
] @scope
