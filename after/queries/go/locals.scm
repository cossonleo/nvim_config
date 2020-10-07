(
	(function_declaration
		name: (identifier) @complete.function)
) 

(
	(type_declaration 
	  (type_spec
		name: (type_identifier) @complete.type)
	)
) 

(source_file
	(var_declaration
		(var_spec
			name: (identifier) @complete.global
		)
	)
)

(source_file
	(const_declaration
		(const_spec
			name: (identifier) @complete.const
		)
	)
)

(
	(function_declaration
		name: (identifier) @decl.function
		body: (block)? @decl_scope_inner) @decl_scope
) 

(
	(method_declaration
		name: (field_identifier) @decl.method
		body: (block)? @decl_scope_inner) @decl_scope
) 

(
	(type_declaration 
	  (type_spec
		name: (type_identifier) @decl.type
		(struct_type
			(field_declaration_list (_)?) @decl_scope_inner
		)
	  )
	) @decl_scope
) 

;(局部变量也会被纳入
;	(var_declaration
;		(var_spec
;			name: (identifier) @decl_ident
;		)
;	)
;)

;(short_var_declaration 
;  left: (expression_list
;          (identifier) @decl_ident
;	  )
;  right: (expression_list
;		(func_literal) @lamda
;	  )
;) 
