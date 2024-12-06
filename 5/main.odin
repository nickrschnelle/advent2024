package main

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

node :: struct {
	after: [dynamic]string,
}

add_ordering :: proc(ordering: []string, node_map: ^map[string]node) {
	for order in ordering {
		parts := strings.split(order, "|")
		number := parts[0]
		after := parts[1]

		ok := number in node_map
		if !ok {
			node_map[number] = node{}
		}
		ptr := &node_map[number]
		append(&ptr.after, after)
	}

}

check_updates :: proc(updates: []string, node_map: ^map[string]node) -> []string {
	total := 0
	bad: [dynamic]string
	out: for update in updates {
		if len(update) == 0 {
			continue
		}
		split := strings.split(update, ",")
		for i in 0 ..< len(split) - 1 {
			b := split[i]
			remainder := split[i + 1:]
			for a in remainder {
				el, ok := node_map[b]
				if !ok || !slice.contains(el.after[:], a) {
					append(&bad, update)
					continue out
				}
			}
		}
		fmt.printfln("%v is correct", split)
		total += strconv.atoi(split[(len(split) - 1) / 2])
	}
	fmt.printfln("total: %v", total)
	return bad[:]
}

part1 :: proc(node_map: ^map[string]node, ordering: []string, updates: []string) -> []string {
	add_ordering(ordering, node_map)
	return check_updates(updates, node_map)
}

get_num_after :: proc(node_map: ^map[string]node, searching: []string, current: string) -> int {
	count := 0
	for s in searching {
		if s == current {
			continue
		}
		ptr := node_map[current]
		if slice.contains(ptr.after[:], s) {
			count += 1
		}
	}
	return count
}

remove_el_slice :: proc(arr: []string, i: int) -> []string {
	fmt.printfln("removing %v from %v", i, arr)
	s := make([]string, len(arr) - 1)
	n := copy(s, arr[:i])
	copy(s[n:], arr[i + 1:])
	return s[:]
}

part2 :: proc(node_map: ^map[string]node, bad_updates: []string) {
	total := 0
	for update in bad_updates {
		split := strings.split(update, ",")
		correct := make([]string, len(split))
		defer delete(correct)
		for s, i in split {
			remainder := remove_el_slice(split[:], i)
			defer delete(remainder)
			depth := get_num_after(node_map, remainder, s)
			fmt.printfln("depth: %v, for %v searching %v", depth, s, remainder)
			correct[depth] = s
		}
		fmt.printfln("bad: %v correct: %v", update, correct)
		total += strconv.atoi(correct[(len(correct) - 1) / 2])
	}
	fmt.println(total)
}

main :: proc() {
	data, success := os.read_entire_file("input")
	if !success {
		return
	}

	node_map := make(map[string]node)
	str_data := string(data)
	lines := strings.split_lines(str_data)
	ordering := lines[0:1176]
	updates := lines[1177:]
	//ordering := lines[0:21]
	//updates := lines[22:]

	fmt.println("part 1")
	bad_updates := part1(&node_map, ordering, updates)
	fmt.println(bad_updates)

	fmt.println("part 2")
	part2(&node_map, bad_updates)

}
