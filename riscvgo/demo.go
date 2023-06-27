package main

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"io/ioutil"
	"os"
	"reflect"
	"strconv"
	"strings"
	"unsafe"
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
	// test memory read/write via fileI/O
	var a, b, c, d, e uint64
	a = 1
	b = 2
	c = a + b // 3
	d = c + a // 4
	e = d * c // 12
	bs := make([]byte, 8)
	// binary.LittleEndian.PutUint32(bs, e)
	cacheWrite("DBG hello", bs)

	// test directly virtual memory write then read
	p := unsafe.Pointer(uintptr(0xd0000deadbee0))
	var pointer *uint64 = (*uint64)(p)
	*pointer = e
	bs = make([]byte, 8)                        // write
	binary.LittleEndian.PutUint64(bs, *pointer) // read to buffer
	cacheWrite("DBG hello", bs)                 // store to file io

	// bs = make([]byte, 7)
	copy(bs, strings.Repeat(strconv.FormatInt(int64(337), 10), 40))
	bs = make([]byte, 1)
	copy(bs, "10")

	// test simple goroutine + channel
	r := make(chan uint32)
	go func() {
		for {
			r <- 0xdead
			r <- 0xbeef
		}
	}()
	bs = make([]byte, 4)
	binary.LittleEndian.PutUint32(bs, <-r)
	cacheWrite("DBG hello", bs)
	binary.LittleEndian.PutUint32(bs, <-r)
	cacheWrite("DBG hello", bs)

	// BUGGY: reproduce byte.Equals alignment bug
	// raised issue https://github.com/golang/go/issues/61018
	var bytesa []byte
	bha := (*reflect.SliceHeader)(unsafe.Pointer(&bytesa))
	bha.Data = uintptr(0xd0000deadbfa2)
	bha.Len = 40
	bha.Cap = 40

	var bytesb []byte
	bhb := (*reflect.SliceHeader)(unsafe.Pointer(&bytesb))
	bhb.Data = uintptr(0xd0000deadbfb2)
	bhb.Len = 40
	bhb.Cap = 40

	bytes.Equal(bytesa, bytesb)
}
