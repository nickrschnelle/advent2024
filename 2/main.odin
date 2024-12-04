package main
import "core:fmt"
import "core:math"
import "core:mem"
import "core:os"
import "core:sort"
import "core:strconv"
import "core:strings"

check :: proc(int_arr: []int) -> bool {
	for i in 1 ..< len(int_arr) {
		if int_arr[i] == int_arr[i - 1] {
			return false
		}
		if math.abs(int_arr[i] - int_arr[i - 1]) > 3 {
			return false
		}
		if int_arr[1] > int_arr[0] && int_arr[i] < int_arr[i - 1] {
			return false
		}
		if int_arr[1] < int_arr[0] && int_arr[i] > int_arr[i - 1] {
			return false
		}
	}

	return true
}

part2 :: proc(str_data: string) {
	str_data := str_data
	count := 0
	for line in strings.split_lines_iterator(&str_data) {
		row, err := strings.split(line, " ")
		if err != nil {
			return
		}
		int_arr := make([]int, len(row))
		defer delete(int_arr)
		for n, i in row {
			int_arr[i] = strconv.atoi(n)
		}
		ok := check(int_arr)
		if ok {
			count += 1
			continue
		}

		for i in 0 ..< len(int_arr) {
			tmp: [dynamic]int
			append(&tmp, ..int_arr[:])
			ordered_remove(&tmp, i)
			inner_ok := check(tmp[:])
			if inner_ok {
				count += 1
				break
			}
		}
	}
	fmt.printfln("count: %v", count)
}

part1 :: proc(str_data: string) {
	str_data := str_data
	count := 0
	for line in strings.split_lines_iterator(&str_data) {
		row, err := strings.split(line, " ")
		if err != nil {
			return
		}
		int_arr := make([]int, len(row))
		defer delete(int_arr)
		for n, i in row {
			int_arr[i] = strconv.atoi(n)
		}
		ok := check(int_arr)
		if ok {
			count += 1
		}
	}
	fmt.printfln("count: %v", count)
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
