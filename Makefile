#Simple makefile: just copies files to $HOME and reloads shell

files := $(shell find . -not -path "./.git/*" -not -name ".git" -path "./*")

all: $(files)
	set -- -f && \
	source bootstrap.sh
