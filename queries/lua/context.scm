(function
 (function_name
  (function_name_field) @context_name))

((function
   (function_name (identifier) @context_name)))

((local_function
   (identifier) @context_name))


[
	(function) 
	(function_definition)
	(local_function)
] @scope

;((function
;   (function_name
;     (function_name_field
;       (identifier) @name.associated
;       (property_identifier) @name.method)) ) @method)
;
;((function 
;    (function_name 
;		(identifier) @name.associated
;		(method) @name.method) 
;	(parameters) @name.param) @method)
;
;((function
;	(function_name 
;		(identifier) @name.func
;	) @name_help (#not-contains? @name_help ":")
;	(parameters) @name.param) @func )
;
;(local_function
;   (identifier) @name.func 
;	(parameters) @name.param) @func
