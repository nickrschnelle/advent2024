package main

import "core:fmt"
import "core:os"
import "core:strings"

search :: proc(str: [][dynamic]string, x: int, y: int) -> int {
	width := len(str[y]) - 1
	height := len(str) - 2
	count := 0
	if x + 3 <= width {
		// search right
		if str[y][x + 1] == "M" && str[y][x + 2] == "A" && str[y][x + 3] == "S" {
			count += 1
		}
	}
	if x - 3 >= 0 {
		// search left
		if str[y][x - 1] == "M" && str[y][x - 2] == "A" && str[y][x - 3] == "S" {
			count += 1
		}
	}
	if y + 3 <= height {
		// search down 
		if str[y + 1][x] == "M" && str[y + 2][x] == "A" && str[y + 3][x] == "S" {
			count += 1
		}
	}
	if y - 3 >= 0 {
		// search up 
		if str[y - 1][x] == "M" && str[y - 2][x] == "A" && str[y - 3][x] == "S" {
			count += 1
		}
	}
	if x + 3 <= width && y + 3 <= height {
		// search down right
		if str[y + 1][x + 1] == "M" && str[y + 2][x + 2] == "A" && str[y + 3][x + 3] == "S" {
			count += 1
		}
	}
	if x - 3 >= 0 && y + 3 <= height {
		// search down left
		if str[y + 1][x - 1] == "M" && str[y + 2][x - 2] == "A" && str[y + 3][x - 3] == "S" {
			count += 1
		}
	}
	if x - 3 >= 0 && y - 3 >= 0 {
		// search up left
		if str[y - 1][x - 1] == "M" && str[y - 2][x - 2] == "A" && str[y - 3][x - 3] == "S" {
			count += 1
		}
	}
	if x + 3 <= width && y - 3 >= 0 {
		// search up right
		if str[y - 1][x + 1] == "M" && str[y - 2][x + 2] == "A" && str[y - 3][x + 3] == "S" {
			count += 1
		}
	}
	return count
}
search_2 :: proc(str: [][dynamic]string, x: int, y: int) -> int {
	width := len(str[y]) - 1
	height := len(str) - 2
	count := 0
	if x + 1 <= width && y + 1 <= height && x - 1 >= 0 && y - 1 >= 0 {
		// S M
		//  A
		// S M
		if str[y + 1][x + 1] == "M" &&
		   str[y + 1][x - 1] == "S" &&
		   str[y - 1][x + 1] == "M" &&
		   str[y - 1][x - 1] == "S" {
			count += 1
		}
		// M S
		//  A
		// M S
		if str[y + 1][x + 1] == "S" &&
		   str[y + 1][x - 1] == "M" &&
		   str[y - 1][x + 1] == "S" &&
		   str[y - 1][x - 1] == "M" {
			count += 1
		}
		// M M
		//  A
		// S S
		if str[y + 1][x + 1] == "S" &&
		   str[y + 1][x - 1] == "S" &&
		   str[y - 1][x + 1] == "M" &&
		   str[y - 1][x - 1] == "M" {
			count += 1
		}
		// S S
		//  A
		// M M
		if str[y + 1][x + 1] == "M" &&
		   str[y + 1][x - 1] == "M" &&
		   str[y - 1][x + 1] == "S" &&
		   str[y - 1][x - 1] == "S" {
			count += 1
		}
	}
	return count
}

part1 :: proc(str: [][dynamic]string) {
	count := 0
	for line, y in str {
		for s, x in line {
			if s == "X" {
				count += search(str, x, y)
			}
		}
	}
	fmt.println(count)
}

part2 :: proc(str: [][dynamic]string) {
	count := 0
	for line, y in str {
		for s, x in line {
			if s == "A" {
				count += search_2(str, x, y)
			}
		}
	}
	fmt.println(count)

}
main :: proc() {
	data, success := os.read_entire_file("input")
	if !success {
		return
	}

	str_data := string(data)
	lines := strings.split_lines(str_data)
	str := make([][dynamic]string, len(lines))
	defer delete(str)
	for line, i in lines {
		for s in strings.split(line, "") {
			append(&str[i], s)
		}
	}

	fmt.println("part 1")
	part1(str)

	fmt.println("part 2")
	part2(str)
}
