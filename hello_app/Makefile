APP_NAME ?= hello_app
APP_BIN ?= $(APP_NAME).bin

PAYLOAD ?= $(shell pwd)/../../arceos/payload
PAYLOAD_BIN ?= apps.bin

default:
	cargo build --target riscv64gc-unknown-none-elf --release

	rust-objcopy --binary-architecture=riscv64 --strip-all -O binary target/riscv64gc-unknown-none-elf/release/$(APP_NAME) ./$(APP_BIN)

	dd if=/dev/zero of=./$(PAYLOAD_BIN) bs=1M count=32
	dd if=./$(APP_BIN) of=./$(PAYLOAD_BIN) conv=notrunc

	mkdir -p $(PAYLOAD)
	mv ./$(PAYLOAD_BIN) $(PAYLOAD)/$(PAYLOAD_BIN)

	xxd -ps ./$(APP_BIN)

clean:
	cargo clean && rm -f $(APP_BIN)
	