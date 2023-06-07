package main

import (
    "io/ioutil"
    "os"
    "encoding/binary"
    "fmt"
)

func toFilename(key string) string {
    return fmt.Sprintf("%s", key)
}

func cacheRead(key string) []byte {
    dat, err := ioutil.ReadFile(toFilename(key))
    if err == nil {
        return dat
    }
    panic("cache missing")
}

func cacheExists(key string) bool {
    _, err := os.Stat(toFilename(key))
    return err == nil
}

func cacheWrite(key string, value []byte) {
    err := ioutil.WriteFile(toFilename(key), value, 0644)
    if err != nil {
        panic("file write error")
    }
}

func main() {
    var a, b, c, d, e uint32
    a = 1
    b = 2
    c = a + b // 3
    d = c + a // 4
    e = d * c // 12
    bs := make([]byte, 8)
    binary.LittleEndian.PutUint32(bs, e)
    cacheWrite("hello", bs)
}
