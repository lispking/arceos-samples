APP ?= hello_app

PAYLOAD_PATH ?= $(shell pwd)/../arceos/payload
PAYLOAD_BIN ?= apps.bin

default:
	cd $(APP) && $(MAKE)

	dd if=/dev/zero of=./$(PAYLOAD_BIN) bs=1M count=32
	dd if=$(APP)/$(APP).bin of=./$(PAYLOAD_BIN) conv=notrunc

	mkdir -p $(PAYLOAD_PATH)
	cp ./$(PAYLOAD_BIN) $(PAYLOAD_PATH)/$(PAYLOAD_BIN)

	xxd -ps $(APP)/$(APP).bin

clean:
	cd hello_app_v1 && $(MAKE) clean
	cd hello_app_v2 && $(MAKE) clean
	cd hello_app_v4 && $(MAKE) clean
