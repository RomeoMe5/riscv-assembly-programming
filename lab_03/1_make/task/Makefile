include Makefile.conf

all: check-tools install-deps

$(HEX): $(ELF)
	$(OBJCOPY) -O ihex $< $@

# Добавьте необходимые для сборки проекта правила
$(ELF):
	echo "Not implemented"
	exit 1
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ $(LDFLAGS) $(LIBS)

upload: check-tools install-deps $(HEX)
	python3 $(UPLOADER_DIR)/mik32_upload.py --run-openocd --openocd-exec=$(OPENOCD) \
	        --openocd-scripts $(UPLOADER_DIR)/openocd-scripts --boot-mode $(BOOT_MODE) \
	        --openocd-interface interface/ftdi/mikron-link.cfg $(HEX)

start-server: check-tools install-deps $(ELF)
	@$(OPENOCD) \
		-f $(UPLOADER_DIR)/openocd-scripts/interface/ftdi/mikron-link.cfg \
		-f $(UPLOADER_DIR)/openocd-scripts/target/mik32.cfg &>/dev/null || \
		{ \
			echo "Failed to start openocd server" && \
			exit 1; \
		}
	$(CROSS_PREFIX)gdb --init-eval-command="target remote :3333" $(ELF)

stop-server: check-tools
	@pid=$$(ps aux | grep '$(OPENOCD)' | grep -v grep | awk '{print $$2}'); \
	if [ -n "$$pid" ]; then \
		echo "Killing openocd (PID $$pid)"; \
		kill -9 $$pid; \
	else \
		echo "openocd is not running"; \
	fi

clean:
	rm -rf $(OBJ) $(BUILD)

purge: clean delete-deps delete-toolchain delete-openocd

.PHONY: all upload clean purge start-server
