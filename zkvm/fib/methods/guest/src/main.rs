use risc0_zkvm::guest::env;

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

fn main() {
    let n = 16; 
    
    // read the input
    let input: u32 = env::read();
    
    let equality_check: String = format!("{} is fibonacci(private n): {}.",input,fib(n)==input);

    // write public output to the journal
    env::commit(&equality_check);
}
