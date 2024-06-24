fn main() -> bool {
    ageverif(16)
}

fn ageverif(mut n: u32) -> bool {
    let mut a: bool = false;
    if n >= 18 {
        a = true;
    }
    a
}

#[cfg(test)]
mod tests {
    use super::ageverif;

    #[test]
    fn it_works_under() {
        assert(ageverif(16) == false, 'it works under!');
    }
    
    #[test]
    fn it_works_over() {
        assert(ageverif(19) == true, 'it works over!');
    }
}
