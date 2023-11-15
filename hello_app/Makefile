
PAYLOAD ?= $(shell pwd)/../../arceos/payload

default:
	cargo build --target riscv64gc-unknown-none-elf --release

	rust-objcopy --binary-architecture=riscv64 --strip-all -O binary target/riscv64gc-unknown-none-elf/release/hello_app ./hello_app.bin

	dd if=/dev/zero of=./apps.bin bs=1M count=32
	dd if=./hello_app.bin of=./apps.bin conv=notrunc

	mkdir -p $(PAYLOAD)
	mv ./apps.bin $(PAYLOAD)/apps.bin

	xxd -ps ./hello_app.bin

clean:
	cargo clean
	