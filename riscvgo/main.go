package main

//go:nosplit
func main() {
    a := 1
    b := 2
    c := a + b
    _ = c + a
}
