autocmd FileType c call BoilerplateC()
fu! BoilerplateC()
    if line('$') == 1
        if expand("%:e") == "h" || expand("%:e") == "hpp"
            call BoilerplateHeader()
        else
            call append(0, "#include <stdio.h>")
            call append(1, "#include <stdlib.h>")
            call append(2, "")
            call append(3, "int main(int argc, char * argv[]){")
            call append(4, "    printf(\"Hello world\\n\");")
            call append(5, "}")
            call cursor(5, 1)
        endif
    endif
endfu

autocmd FileType cpp call BoilerplateCPP()
fu! BoilerplateCPP()
    if line('$') == 1
        if expand("%:e") == "h" || expand("%:e") == "hpp"
            call BoilerplateHeader()
        else
            call append(0, "#include <iostream>")
            call append(1, "")
            call append(2, "auto main(int argc, char * argv[]) -> int {")
            call append(3, "    std::cout << \"Hello world\" << std::endl;")
            call append(4, "}")
            call cursor(4, 1)
        endif
    endif
endfu

fu! BoilerplateHeader()
    let l:name = expand("%:r")
    let l:name_snake = substitute(l:name, '([A-Z])', '_\1', 'g')
    let l:name_scream = toupper(l:name_snake)
    echo l:name_scream
    call append(0, '#ifndef '.l:name_scream.'_H')
    call append(1, '#define '.l:name_scream.'_H')
    call append(2, '')
    call append(3, "#endif")
    call cursor(3, 1)
endfu

autocmd FileType rust call BoilerplateRS()
fu! BoilerplateRS()
    if line('$') == 1
        call append(0, "fn main() {")
        call append(1, "")
        call append(2, "}")
        call cursor(2, 1)
    endif
endfu

autocmd FileType java call BoilerplateJava()
fu! BoilerplateJava()
    if line('$') == 1
        call append(0, "import java.util.*;")
        call append(1, "")
        call append(2, "public class ".expand('%:r')." {")
        call append(3, "    public static void main(String[] args) {")
        call append(4, "        System.out.println(\"Hello world\");")
        call append(5, "    }")
        call append(6, "}")
        call cursor(5, 1)
    endif
endfu
autocmd FileType html call BoilerplateHtml()
fu! BoilerplateHtml()
    if line('$') == 1
        call append(0, "<!DOCTYPE html>")
        call append(1, "<html>")
        call append(2, "    <head>")
        call append(3, "        <title>".expand('%:r')."</title>")
        call append(4, "    </head>")
        call append(5, "    <body>")
        call append(6, "")
        call append(7, "    </body>")
        call append(8, "</html>")
        call cursor(7, 1)
    endif
endfu
