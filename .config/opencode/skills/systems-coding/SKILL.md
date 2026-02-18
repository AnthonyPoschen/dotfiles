---
name: systems-coding
description: >
  MANDATORY. Auto-activates for ANY Go (*.go), Zig, C, C++, C# codegen/editing task.
  Detects language from file extension or "golang/go" mention. ALWAYS apply.
  Produces natural, clean, idiomatic, highly readable code.
---
**Target Languages:** Go, Zig, C, C++, C#
**Core Guidelines:**
* **Early Returns**
  * Always use guard clauses / early returns to avoid nested ifs. Keep code flat.
  * When considering if else blocks, if the "else" will result in an early return
    then instead do 2 if's and put the early return option first
  * fail case if statements are independent single checks done first
* **Line Length**
  * Ideal length under 80 characters.
* **Variables**
  * MUST avoid global variables
  * prefer const when suitable
  * prefer variables over magic values for complex functions
* **Functions**
  * break complex functions when
    * reuse of a part of the function will occur
    * function performs many logical calculations over lots of lines
* **Magic Values**
  * usage for simple once off parameters
  * avoid usage when it is used multiple times in the same scope
* **Comments**
  * do not narrate everything
    * place strategic short comments in complex functions to denote when the function
      starts performing completely different types of actions.
  * Function definition's MUST HAVE comments to enhance LSP documentation output
    for the developer
