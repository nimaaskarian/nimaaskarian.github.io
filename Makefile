blogs := $(wildcard _posts/*.md)

index.md: $(blogs) .index.md
	cat .index.md > index.md
	echo $(blogs)
	$(foreach blog, ${blogs}, grep '^# ' ${blog} | head -n 1 | cut -d ' ' -f 2- | xargs -I{} printf "[%s](${blog})\n" "{}") | head -n 20 >> index.md

.PHONY: index.md
