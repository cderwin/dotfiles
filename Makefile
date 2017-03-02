NOINSTALL_DIRS := install/
PACKAGES := $(filter-out $(NOINSTALL_DIRS),$(wildcard */))

.PHONY: install uninstall update pull

install:
	stow -t ~ $(PACKAGES)

uninstall:
	stow -Dt ~ $(PACKAGES)

pull:
	git pull

update: pull install
