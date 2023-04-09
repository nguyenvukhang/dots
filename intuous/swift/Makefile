MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_DIR  := $(dir $(MAKEFILE_PATH))
TARGET_BIN := $(MAKEFILE_DIR)/../Cycle.app/Contents/MacOS/Cycle
OUTPUT_BIN := $(MAKEFILE_DIR)/.build/release/intuous

debug:
	swift run

release:
	swift build --configuration release

fmt:
	swiftformat .

all:
	@make release
	@rm -f $(TARGET_BIN)
	@cp $(OUTPUT_BIN) $(TARGET_BIN)
	wc -c $(TARGET_BIN)

open:
	open ../Cycle.app

size:
	wc -c $(TARGET_BIN)
