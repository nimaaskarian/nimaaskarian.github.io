blogs := $(wildcard _posts/*.md)

index.md: $(blogs) .index.md
	cat .index.md > index.md
	echo $(blogs)
	./recent-blogs.sh | head -n 20 >> index.md

.PHONY: index.md
