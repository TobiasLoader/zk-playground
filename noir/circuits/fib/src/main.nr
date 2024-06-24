fn main(n: u32, v: pub u32) {
    assert(fib(n) == v);
}

fn fib(n: u32) -> u32 {
    let mut a: u32 = 0;
    let mut b: u32 = 1;
    
    // Assume a maximum number of iterations, say 100
    for i in 0..100 {
        // Compute the Fibonacci value only up to the nth term
        let temp = b;
        b = if i < n { a + b } else { b };
        a = if i < n { temp } else { a };
    }
    a
}

#[test]
fn correct_16() {
    assert(fib(16) == 987);
}
#[test]
fn incorrect_15() {
    assert(fib(15) != 987);
}