MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_DIR  := $(dir $(MAKEFILE_PATH))

TARGET_BIN:=../Cycle.app/Contents/MacOS/Cycle
BUILD:=cc -framework Cocoa

dev:
	$(BUILD) -o $(TARGET_BIN) main.m
	$(TARGET_BIN)
	@echo "build size:"
	@make size

install: 
	rm -f $(TARGET_BIN)
	$(BUILD) -o $(TARGET_BIN) main.m

size:
	wc -c $(TARGET_BIN)
