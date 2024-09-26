extends Control

@onready var panel: Panel = $Panel
const CELL = preload("res://G2048/cell.tscn")
const max_count:int = 5 * 5
var map = {}

func instantiate_cell(x, y):
	var cell = CELL.instantiate()
	cell.grid_pos = Vector2i(x, y)
	panel.add_child(cell)
	map[cell.get_instance_id()] = cell

func _ready() -> void:
	random_create_cell(3)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		merge_cell(event.keycode)
		random_create_cell(2)
		print(map)
		
func random_create_cell(count:int = 1):
	var array = []
	for i in range(max_count):
		if not map.erase(i):
			array.append(i)
	if array.size() >= count:
		@warning_ignore("narrowing_conversion")
		seed(Time.get_unix_time_from_system())
		array.shuffle()
		for i in range(count):
			var number = array[i]
			var x:int = number % 5
			var y:int = number / 5
			instantiate_cell(x, y)
	else:
		pass 

func merge_cell(keycode:int):
	var merge_map = {}
	var dir = null
	var add = null
	match(keycode):
		KEY_UP:
			dir = "x"
			add = 1
		KEY_DOWN:
			dir = "x"
			add = -1
		KEY_RIGHT:
			dir = "y"
			add = -1
		KEY_LEFT:
			dir = "y"
			add = 1
		_:
			return
	
	merge_map = select_and_sort(dir, add, merge_map)
	
	for i in merge_map:
		var array = merge_map[i]
		var new_array = []

		if add > 0 :
			for ii in range(array.size(), 0, -1):
				var cell = array[ii - 1]
				new_array = add_new_array(new_array, cell)
		else:
			for ii in range(array.size()):
				var cell = array[ii]
				add_new_array(new_array, cell)
		update_cell_data(new_array, dir, add)

func add_new_array(new_array, cell):
	if new_array.size() == 0:
		new_array.append(cell)
	else:
		if new_array[-1].number == cell.number:
			new_array[-1].number += cell.number
			var idx = cell.get_instance_id()
			map.erase(idx)
			cell.free()
		else:
			new_array.append(cell)
	return new_array

func update_cell_data(new_array, dir, add):
	for ii in range(new_array.size()):
		var new_pos = Vector2i.ZERO
		if dir == "x" :
			new_pos.x = new_array[ii].grid_pos.x
			if add > 0 :
				new_pos.y = ii
			else:
				new_pos.y = 4 - ii
		else:
			new_pos.y = new_array[ii].grid_pos.y
			if add > 0 :
				new_pos.x = ii
			else:
				new_pos.x = 4 - ii
		new_array[ii].refresh_view(new_pos, new_array[ii].number)

func select_and_sort(dir, add, merge_map):
	for key in map.keys():
		var cell = map[key]
		if not merge_map.has(cell.grid_pos[dir]):
			merge_map[cell.grid_pos[dir]] = []
		var list = merge_map.get(cell.grid_pos[dir])
		list.insert(list.bsearch_custom(cell, func(a, b):
			if add > 0: 
				return a.grid_pos[dir] > b.grid_pos[dir]
			else:
				return a.grid_pos[dir] < b.grid_pos[dir]
			, true), cell)
	return merge_map
