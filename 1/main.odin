package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:sort"
import "core:strconv"
import "core:strings"

part1 :: proc(str_data: string) {
	str_data := str_data
	arr1: [dynamic]int
	arr2: [dynamic]int
	for line in strings.split_lines_iterator(&str_data) {
		cols, err := strings.split_n(line, "   ", 2)
		if err != nil {
			return
		}
		n1, ok1 := strconv.parse_int(cols[0])
		if !ok1 {
			return
		}

		n2, ok2 := strconv.parse_int(cols[1])
		if !ok2 {
			return
		}
		append(&arr1, n1)
		append(&arr2, n2)
	}

	sort.bubble_sort(arr1[:])
	sort.bubble_sort(arr2[:])
	distance := 0

	for v, i in arr1 {
		distance = distance + math.abs(v - arr2[i])
	}
	fmt.printfln("Distance: %v", distance)

}

part2 :: proc(str_data: string) {
	str_data := str_data
	arr1: [dynamic]int
	arr2: [dynamic]int
	for line in strings.split_lines_iterator(&str_data) {
		cols, err := strings.split_n(line, "   ", 2)
		if err != nil {
			return
		}
		n1, ok1 := strconv.parse_int(cols[0])
		if !ok1 {
			return
		}

		n2, ok2 := strconv.parse_int(cols[1])
		if !ok2 {
			return
		}
		append(&arr1, n1)
		append(&arr2, n2)
	}

	sort.bubble_sort(arr1[:])
	sort.bubble_sort(arr2[:])
	total := 0
	for a in arr1 {
		count := 0
		for b in arr2 {
			if a == b {
				count += 1
			}
		}
		total = total + (a * count)
	}
	fmt.printfln("%v", total)
}
main :: proc() {
	data, success := os.read_entire_file("input")
	if !success {
		return
	}

	str_data := string(data)

	fmt.println("part 1")
	part1(str_data)

	fmt.println("part 2")
	part2(str_data)
}
