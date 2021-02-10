autocmd FileType c call BoilerplateC()
fu! BoilerplateC()
    if line("$") == 1
        call append(0, "#include <stdio.h>")
        call append(1, "#include <stdlib.h>")
        call append(2, "")
        call append(3, "int main(void){")
        call append(4, "	printf(\"Hello world\\n\");")
        call append(5, "}")
    endif
endfu

autocmd FileType cpp call BoilerplateCPP()
fu! BoilerplateCPP()
    if line("$") == 1
        call append(0, "#include <iostream>")
        call append(1, "")
        call append(2, "auto main() -> int {")
        call append(3, "	std::cout << \"Hello world\" << std::endl;")
        call append(4, "}")
    endif
endfu

autocmd FileType rust call BoilerplateRS()
fu! BoilerplateRS()
    if line("$") == 1
        call append(0, "fn main() {")
        call append(1, "}")
    endif
endfu

autocmd FileType java call BoilerplateJava()
fu! BoilerplateJava()
    if line("$") == 1
        call append(0, "import java.util.*;")
        call append(2, "public class ".expand('%:r')." {")
        call append(3, "	public static void main(String[] args) {")
        call append(4, "		System.out.println(\"Hello world\");")
        call append(5, "	}")
        call append(6, "}")
    endif
endfu
autocmd FileType html call BoilerplateHtml()
fu! BoilerplateHtml()
    if line("$") == 1
        call append(0, "<!DOCTYPE html>")
        call append(1, "<html>")
        call append(2, "<head>")
        call append(3, "	<title>".expand('%:r')."</title>")
        call append(4, "</head>")
        call append(5, "<body>")
        call append(6, "</body>")
        call append(7, "</html>")
    endif
endfu
