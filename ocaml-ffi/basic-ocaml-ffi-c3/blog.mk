.PHONY: all clean 

all:
	sh ~/scraps/tools/codeblog/codeblog.sh -title srctxt basic-ocaml-ffi-cfile readme.txt basicmath.c basicmath.h main.ml stubs_basicmath.c Makefile

clean:
	find . -maxdepth 1 -mindepth 1 -type d -exec rm -rf '{}' \;
	rm -f *.html
	rm -f *.zip


