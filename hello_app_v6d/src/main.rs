#![feature(asm_const)]
#![no_std]
#![no_main]
use core::{panic::PanicInfo, arch::asm};

// const SYS_HELLO: usize = 1;
const SYS_PUTCHAR: usize = 2;
static mut ABI_ENTRY: usize = 0;

#[no_mangle]
#[link_section = ".text.entry"]
unsafe extern "C" fn _start(abi_entry: usize) {
    ABI_ENTRY = abi_entry;

    putchar(b'D');
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[macro_export]
macro_rules! abi_call {
    ($abi_num: expr, $arg0: expr) => {{
        unsafe {
            asm!("
                li      a0, {abi_num}
                slli    t0, t0, 3
                la      t1, {abi_entry}
                ld      t1, (t1)
                jalr    t1",
                abi_num = const $abi_num,
                abi_entry = sym ABI_ENTRY,
                in("a1") $arg0,
                clobber_abi("C"),
            )
        }
    }}
}

fn putchar(c: u8) {
    abi_call!(SYS_PUTCHAR, c);
}
