APP_NAME ?= hello_app_v6
APP_BIN ?= $(APP_NAME).bin

default:
	cargo build --target riscv64gc-unknown-none-elf --release
	rust-objcopy --binary-architecture=riscv64 --strip-all -O binary target/riscv64gc-unknown-none-elf/release/$(APP_NAME) ./$(APP_BIN)

clean:
	cargo clean && rm -f $(APP_BIN)
	