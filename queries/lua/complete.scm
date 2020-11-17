((function
   (function_name
     (function_name_field) @name)))

((function
   (function_name (identifier) @name)))

((local_function
   (identifier) @name))


(function) @func
(function_definition) @func
(local_function) @func

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
