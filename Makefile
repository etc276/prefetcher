CFLAGS = -msse2 --std gnu99 -O0 -Wall -Wextra

EXEC = naive_transpose sse_transpose sse_prefetch_transpose
GIT_HOOKS := .git/hooks/applied
CC ?= gcc


naive_transpose: main.c
	$(CC) $(CFLAGS) -DNAIVE_TRANSPOSE -o $@ main.c

sse_transpose: main.c
	$(CC) $(CFLAGS) -DSSE_TRANSPOSE -o $@ main.c

sse_prefetch_transpose: main.c
	$(CC) $(CFLAGS) -DSSE_PREFETCH_TRANSPOSE -o $@ main.c 

all: $(GIT_HOOKS) $(EXEC)

$(GIT_HOOKS):
	@scripts/install-git-hooks
	@echo

clean:
	$(RM) main
