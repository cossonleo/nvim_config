
if exists("b:is_load")
	"finish
endif

let b:is_load = 1

syn match log_err '.*\<\(EROR\|ERROR\|FATAL\|FAIL\|FAILED\|FAILURE\).*'
syn match log_warn '.*\<\(WARN\|WARNING\).*'
syn match log_track '.*\<\(TRACK\|TRAC\|TRACING\).*'
syn match log_info '.*\<INFO.*'
syn match log_debug '.*\<\(DEBUG\|debug\).*'

hi def link log_err NeomakeErrorSign
hi def link log_warn NeomakeWarningSign
hi def link log_info NeomakeInfoSign
hi def link log_track Comment
hi def link log_debug Debug
