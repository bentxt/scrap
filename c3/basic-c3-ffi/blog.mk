.PHONY: all clean 

all:
	sh ~/scraps/tools/codeblog/codeblog.sh basic-c3-ffi readme.txt c3math.c3 main.c stubs_c3math.c Makefile


clean:
	find . -maxdepth 1 -mindepth 1 -type d -exec rm -rf '{}' \;
	rm -f *.html
	rm -f *.zip


