#!/usr/bin/env make

AS = nasm
ASFLAGS = -felf64

vpath %.s src
vpath %.o build

OBJS = test.o

%.o: %.s
	$(AS) $(ASFLAGS) -o build/$@ $<

build: build_dir aoc1

aoc1: aoc1.o
	gcc build/aoc1.o -o aoc1

.PHONY: build_dir
build_dir:
	mkdir -p build

.PHONY: clean
clean:
	rm -rf build/ aoc1
