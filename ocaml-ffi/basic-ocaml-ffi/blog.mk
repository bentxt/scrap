.PHONY: all clean cleanblog blog

cleanblog:
	find . -maxdepth 1 -mindepth 1 -type d -exec rm -rf '{}' \;
	rm -f *.html
	rm -f *.zip


blog:
	sh ~/scraps/tools/codeblog/codeblog.sh basic-ocaml-ffi readme.txt Makefile main.ml hello_stubs.c
