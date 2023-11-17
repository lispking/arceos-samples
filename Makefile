APP ?= hello_app

DIRS := $(shell ls -d */)

PAYLOAD_PATH ?= $(shell pwd)/../arceos/payload
PAYLOAD_BIN ?= apps.bin

compile:
	cd $(APP) && $(MAKE)

default: compile
	dd if=/dev/zero of=./$(PAYLOAD_BIN) bs=1M count=32
	dd if=$(APP)/$(APP).bin of=./$(PAYLOAD_BIN) conv=notrunc

	mkdir -p $(PAYLOAD_PATH)
	mv ./$(PAYLOAD_BIN) $(PAYLOAD_PATH)/$(PAYLOAD_BIN)

	xxd -ps $(APP)/$(APP).bin

clean:
	$(foreach N,$(DIRS),$(MAKE) -C $(N) clean;)
