

(function_item 
  name: (identifier) @context_name)

; Types
(struct_item
  name: (type_identifier) @context_name)

(constrained_type_parameter 
  left: (type_identifier) @context_name) ; the P in  remove_file<P: AsRef<Path>>(path: P)

(enum_item
  name: (type_identifier) @context_name)

(trait_item 
	(visibility_modifier) 
	name: (type_identifier) @context_name)

; Scopes
[
; (block)
 (function_item)
; (closure_expression)
; (while_expression)
; (for_expression)
; (loop_expression)
; (if_expression)
; (if_let_expression)
; (match_expression)
; (match_arm)
;
 (struct_item)
 (enum_item)
 (impl_item)
 (trait_item)
] @scope
