class_name Utils

extends Node

static func reversed(original_array):
	var cloned_array = original_array
	cloned_array.reverse()
	return cloned_array

static func sorted(original_array):
	var cloned_array = original_array
	cloned_array.sorted()
	return cloned_array

static func sorted_custom(original_array, sort_func):
	var cloned_array = original_array
	cloned_array.sort_custom(sort_func)
	return cloned_array
