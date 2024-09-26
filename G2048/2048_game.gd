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
	var k = null
	var add = null
	match(keycode):
		KEY_UP:
			k = "x"
			add = -1
		KEY_DOWN:
			k = "x"
			add = 1
		KEY_RIGHT:
			k = "y"
			add = 1
		KEY_LEFT:
			k = "y"
			add = -1
		_:
			return
	
	for key in map.keys():
		var cell = map[key]
		if not merge_map.has(cell.grid_pos[k]):
			merge_map[cell.grid_pos[k]] = []
		var list = merge_map.get(cell.grid_pos[k])
		list.insert(list.bsearch_custom(cell, func(a, b):
			if add > 0: 
				return a.grid_pos[k] > b.grid_pos[k]
			else:
				return a.grid_pos[k] < b.grid_pos[k]
			, true), cell)
	
	
	for i in merge_map:
		var list = merge_map[i]
		var new_array = []
		for ii in range(list.size(), 0, -1):
			var cell = list[ii - 1]
			if new_array.size() == 0:
				new_array.append(cell)
			else:
				if new_array[-1].number == list[ii - 1].number:
					new_array[-1].number += list[ii - 1].number
					var idx = cell.get_instance_id()
					map.erase(idx)
					cell.free()
				else:
					new_array.append(cell)
		for ii in range(new_array.size()):
			var new_pos = Vector2i.ZERO
			if k == "x" :
				new_pos.x = new_array[ii].grid_pos.x
				new_pos.y = ii
			else:
				new_pos.y = new_array[ii].grid_pos.y
				new_pos.x = ii
			new_array[ii].refresh_view(new_pos, new_array[ii].number)
	
