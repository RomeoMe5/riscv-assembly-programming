CC ?= gcc
CFLAGS := -O0 -g

BUILD = build
SRC   = src
OBJ   = obj

# pwd from Makefile-script directory and extract directory name
PROJECT_NAME ?= $(shell basename "$(shell cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd)")

SOURCES := $(wildcard $(SRC)/*.c $(SRC)/*.S)
OBJECTS := $(filter %.o,$(SOURCES:%.c=%.o) $(SOURCES:%.S=%.o))
OBJECTS := $(addprefix $(OBJ)/,$(OBJECTS))
OUT ?= $(BUILD)/$(PROJECT_NAME)

all: $(OUT)

$(OUT): $(OBJECTS) | $(BUILD)
	$(CC) $(CFLAGS) $^ -o $@

$(OBJ)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

$(OBJ)/%.o: %.S
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILD):
	@mkdir -p $@

clean:
	rm -rf $(OBJ) $(BUILD)

.PHONY: all clean
