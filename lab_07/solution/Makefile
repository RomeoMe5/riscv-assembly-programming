CC ?= gcc
CFLAGS := -Os -g -nostartfiles

BUILD = build
SRC   = src
OBJ   = obj
OUT   = $(BUILD)/lab_07

SOURCES := $(wildcard $(SRC)/*.S)
OBJECTS := $(SOURCES:$(SRC)/%.S=$(OBJ)/%.o)
OUT ?= $(BUILD)/$(PROJECT_NAME)

all: $(OUT)

$(OUT): $(OBJECTS) | $(BUILD)
	$(CC) $(CFLAGS) $^ -o $@

$(OBJ)/%.o: $(SRC)/%.S | $(OBJ)
	$(CC) -c $(CFLAGS) $< -o $@

$(OBJ):
	@mkdir -p $@

$(BUILD):
	@mkdir -p $@

clean:
	rm -rf $(OBJ) $(BUILD)

.PHONY: all clean
