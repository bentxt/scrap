.PHONY: clean

cb=$(HOME)/kits/toolkit/tools/codeblog/codeblog.sh

all: clean
	@dash $(cb) helloworld.c
	@echo codeblog finished ...

clean:
	@rm -f *.html *.zip
	@#delete all files w/o extension and subdirs
	@find .  ! -name "*.*"  -delete
	@echo codeblog output cleaned ....



