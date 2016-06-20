all: discontiguous-io/discontiguous-io README.html shellcheck

discontiguous-io/discontiguous-io:
	$(MAKE) -C discontiguous-io discontiguous-io

README.html: README.md
	{							\
	  echo '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8"><title>SRP Test Suite</title></head><body>';	\
	  for markdown in Markdown.pl markdown; do		\
	    type $$markdown >/dev/null 2>&1 && break;		\
	  done;							\
	  $$markdown <"$<";					\
	  echo '</body></html>';				\
	} >"$@"

shellcheck:
	shellcheck -x -f gcc run_tests lib/functions tests/*[^~]

.PHONY: discontiguous-io/discontiguous-io shellcheck
