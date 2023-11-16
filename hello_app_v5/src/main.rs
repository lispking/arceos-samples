#![feature(asm_const)]
#![no_std]
#![no_main]
use core::{panic::PanicInfo, arch::asm};

const SYS_HELLO: usize = 1;
const SYS_PUTCHAR: usize = 2;
const SYS_TERMINATE: usize = 3;
static mut ABI_ENTRY: usize = 0;

#[no_mangle]
#[link_section = ".text.entry"]
unsafe extern "C" fn _start(abi_entry: usize) -> ! {
    ABI_ENTRY = abi_entry;

    hello();
    puts("ArceOS v5678!");
    terminate(0);
    wfi();
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

fn hello() {
    abi_call!(SYS_HELLO, 0);
}

fn putchar(c: u8) {
    abi_call!(SYS_PUTCHAR, c);
}

fn terminate(exit_code: i32) {
    abi_call!(SYS_TERMINATE, exit_code);
}

fn puts(s: &str) {
    s.chars().for_each(|c| {
        putchar(c as u8)
    });
}

fn wfi() -> ! {
    unsafe {
        core::arch::asm!("
            wfi",
            options(noreturn),
        )
    }
}