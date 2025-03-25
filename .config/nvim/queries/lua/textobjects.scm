; Single-line comments (consecutive -- lines)
((comment) @comment.outer
 (#match? @comment.outer "^--[^\\[]"))
; Inner for single-line (excludes --)
((comment) @comment.inner
 (#match? @comment.inner "^--[^\\[]")
 (#offset! @comment.inner 0 2 0 0))

; Multi-line comments (--[[ ... ]])
((comment) @comment.outer
 (#match? @comment.outer "^--\\[\\["))
; Inner for multi-line (excludes --[[ and ]])
((comment) @comment.inner
 (#match? @comment.inner "^--\\[\\[")
 (#offset! @comment.inner 0 4 0 -2))
