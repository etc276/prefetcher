CFLAGS = -msse2 --std gnu99 -O0 -Wall -Wextra -mavx2

EXEC = naive_transpose sse_transpose sse_prefetch_transpose avx_transpose avx_prefetch_transpose
GIT_HOOKS := .git/hooks/applied
CC ?= gcc


naive_transpose: main.c
	$(CC) $(CFLAGS) -DNAIVE_TRANSPOSE -o $@ main.c

sse_transpose: main.c
	$(CC) $(CFLAGS) -DSSE_TRANSPOSE -o $@ main.c

sse_prefetch_transpose: main.c
	$(CC) $(CFLAGS) -DSSE_PREFETCH_TRANSPOSE -o $@ main.c 

avx_transpose: main.c
	$(CC) $(CFLAGS) -DAVX_TRANSPOSE -o $@ main.c

avx_prefetch_transpose: main.c
	$(CC) $(CFLAGS) -DAVX_PREFETCH_TRANSPOSE -o $@ main.c

all: $(GIT_HOOKS) $(EXEC)

$(GIT_HOOKS):
	@scripts/install-git-hooks
	@echo

perf: $(EXEC)
	perf stat --repeat 5 \
		-e cache-misses,cache-references,instructions,cycles \
		./naive_transpose
	perf stat --repeat 5 \
		-e cache-misses,cache-references,instructions,cycles \
		./sse_transpose
	perf stat --repeat 5 \
		-e cache-misses,cache-references,instructions,cycles \
		./sse_prefetch_transpose
	perf stat --repeat 5 \
                -e cache-misses,cache-references,instructions,cycles \
                ./avx_transpose
	perf stat __repeat 5 \
                -e cache-misses,cache-references,instructions,cycles \
                ./avx_prefetch_transpose

clean:
	$(RM) main
