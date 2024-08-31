write haxe with 
- syntax highlighting 
- lsp completion
- debugging (including ui) (hashlink only)

to make it work  
- build a haxe-language-server 
- build a hashlink-debugger
- grep 'path/to/your' and replace with the binaries from those steps
- hardcode your hxml details (you saw this when you grepd)

you can buildd with :make and you can debug with f5

this is the best if not only way to write haxe and debug hashlink in neovim
