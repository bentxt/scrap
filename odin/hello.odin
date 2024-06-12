package main

import "core:fmt"
import "core:os"
import "core:strings"


read_file_by_lines_in_whole :: proc(filepath: string) {

    x: int = 1.0

	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		// could not read file
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		// process line
	}

}


main :: proc() {
	fmt.println("Hellope!")
    for i := 0; i< 10; i += 1 {
        fmt.println(i)
    }
    read_file_by_lines_in_whole ("test.txt")
}
