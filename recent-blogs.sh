for blog in _posts/*-*-*-*.md; do
  title=$(grep '^# ' ${blog} | head -n 1 | cut -d ' ' -f 2-)
  url=$(basename ${blog} | cut -d - -f -3 | tr - /)/$(echo ${blog} | cut -d - -f 4-)
  printf "[%s](%s)\n" "$title" "$url"
done
