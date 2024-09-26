extends Control

@onready var panel: Panel = $Panel
const CELL = preload("res://G2048/cell.tscn")
const max_count: int = 5 * 5
const next_create_count: int = 2
var cell_dict = {}

enum E_DIR
{
	up, down, right, left
}
var cur_dir = E_DIR.up

func instantiate_cell(x, y):
	var cell = CELL.instantiate()
	cell.grid_pos = Vector2i(x, y)
	panel.add_child(cell)
	cell_dict[cell.get_instance_id()] = cell

func _ready() -> void:
	random_create_cell(3)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		merge_cell(event.keycode)

func is_empty(x: int, y: int) -> bool:
	for k in cell_dict:
		var cell = cell_dict[k]
		if cell.grid_pos.x == x and cell.grid_pos.y == y:
			return false
	return true

func random_create_cell(count: int = 1):
	var array = []
	for number in range(max_count):
		var x: int = number % 5
		var y: int = number / 5
		if is_empty(x, y):
			array.append([x, y])
	if array.size() >= count:
		array.shuffle()
		for i in range(count):
			var data = array[i]
			instantiate_cell(data[0], data[1])
	else:
		print("你输了~")
 

func merge_cell(keycode: int):
	match (keycode):
		KEY_UP:
			cur_dir = E_DIR.up
		KEY_DOWN:
			cur_dir = E_DIR.down
		KEY_RIGHT:
			cur_dir = E_DIR.right
		KEY_LEFT:
			cur_dir = E_DIR.left
		_:
			return

	var merge_cell_list = select_and_sort()
	
	for i in merge_cell_list:
		var array = merge_cell_list[i]
		var new_array = []

		if cur_dir == E_DIR.right or cur_dir == E_DIR.down:
			for ii in range(array.size(), 0, -1):
				var cell = array[ii - 1]
				new_array = add_new_array(new_array, cell)
		else:
			for ii in range(array.size()):
				var cell = array[ii]
				add_new_array(new_array, cell)
			
		update_cell_data(new_array)

	random_create_cell(next_create_count)

func add_new_array(new_array, cell):
	if new_array.size() == 0:
		new_array.append(cell)
	else:
		if new_array[-1].number == cell.number:
			new_array[-1].number += cell.number
			var idx = cell.get_instance_id()
			cell_dict.erase(idx)
			cell.disappear(new_array[-1].position)
		else:
			new_array.append(cell)
	return new_array

func update_cell_data(new_array):
	for ii in range(new_array.size()):
		var new_pos = Vector2i.ZERO
		if cur_dir == E_DIR.down:
			new_pos.x = new_array[ii].grid_pos.x
			new_pos.y = 4 - ii
		elif cur_dir == E_DIR.up:
			new_pos.x = new_array[ii].grid_pos.x
			new_pos.y = ii
		elif cur_dir == E_DIR.right:
			new_pos.x = 4 - ii
			new_pos.y = new_array[ii].grid_pos.y
		else:
			new_pos.x = ii
			new_pos.y = new_array[ii].grid_pos.y
		new_array[ii].refresh_view(new_pos, new_array[ii].number)

func select_and_sort():
	var condition = cur_dir == E_DIR.left or cur_dir == E_DIR.right
	var k = "y" if condition else "x"
	var merge_map = {}
	for key in cell_dict.keys():
		var cell = cell_dict[key]
		if not merge_map.has(cell.grid_pos[k]):
			merge_map[cell.grid_pos[k]] = []

		var list = merge_map.get(cell.grid_pos[k])
		
		list.insert(list.bsearch_custom(cell, func(a, b):
			if cur_dir == E_DIR.up or cur_dir == E_DIR.left:
				return a.grid_pos[k] > b.grid_pos[k]
			else:
				return a.grid_pos[k] < b.grid_pos[k]
			, true), cell)
	return merge_map
