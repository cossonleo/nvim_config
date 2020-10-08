((function_declaration
		name: (identifier) @complete_item
		(parameter_list
			(parameter_declaration
				(identifier) @complete_item)) @complete_def) @complete_context)

;((function_declaration
	
((type_declaration 
	(type_spec
		name: (type_identifier) @complete_item))) @complete_context

(source_file
	(var_declaration
		(var_spec
			name: (identifier) @complete_item))) 

(source_file
	(const_declaration
		(const_spec
			name: (identifier) @complete_item)))

((short_var_declaration 
    left: (expression_list
			  (identifier) @complete_item )) @complete_def)

(func_literal) @complete_context
(source_file) @complete_context
(if_statement) @complete_context
(block) @complete_context_pre
(for_statement) @complete_context
(method_declaration) @complete_context

;(
;	(function_declaration
;		name: (identifier) @decl.function) @decl_scope
;) 
;
;(
;	(method_declaration
;		name: (field_identifier) @decl.method
;		body: (block)? @decl_scope_inner)  @decl_scope
;)
;
;((type_declaration 
;	  (type_spec
;		name: (type_identifier) @decl.type
;		(struct_type
;			(field_declaration_list (_)?) @decl_scope_inner))) @decl_scope) 
;
;
;((var_spec 
;  name: (identifier) @decl.var))


;(局部变量也会被纳入
;	(var_declaration
;		(var_spec
;			name: (identifier) @decl_ident
;		)
;	)
;)

;(
;	(short_var_declaration 
;	  left: (expression_list
;			  (identifier) @decl.var
;		  )
;	  right: (expression_list
;			(func_literal) @lamda
;		  )
;	) 
;)
