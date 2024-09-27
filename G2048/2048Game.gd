extends Control

@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label
const CELL = preload("res://G2048/2048Cell.tscn")
const max_count: int = 5 * 5
const hight = 5
const width = 5
const next_create_count: int = 2
var cell_dict = {}

enum E_DIR
{
	up, down, right, left
}
var cur_dir = E_DIR.up
var integral = 0
var max_number = 0

func instantiate_cell(x, y):
	var cell = CELL.instantiate()
	cell.grid_pos = Vector2i(x, y)
	panel.add_child(cell)
	cell_dict[cell.get_instance_id()] = cell

func _ready() -> void:
	random_create_cell(3)
	refresh_view()

func refresh_view():
	label.text = "当前分数:{0}，最大值：{1}".format([integral, max_number])
	
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
	for x in range(width):
		for y in range (hight):
			if is_empty(x, y):
				array.append([x, y])

	var is_lose = array.size() == 0
	if not is_lose:
		array.shuffle()
		var time = count if count <= array.size() else array.size()
		for i in range(time):
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
			integral += cell.number
			max_number = max_number if max_number > new_array[-1].number else new_array[-1].number
			refresh_view()
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
	var merge_map = {}
	for key in cell_dict.keys():
		var cell = cell_dict[key]
		if cur_dir == E_DIR.left or cur_dir == E_DIR.right:
			if not merge_map.has(cell.grid_pos.y):
				merge_map[cell.grid_pos.y] = []
			var list = merge_map.get(cell.grid_pos.y)
			list.append(cell)
		else:
			if not merge_map.has(cell.grid_pos.x):
				merge_map[cell.grid_pos.x] = []
			var list = merge_map.get(cell.grid_pos.x)
			list.append(cell)
	
	for key in merge_map:
		merge_map[key].sort_custom(sort_func)
	return merge_map

func sort_func(a, b):
	if cur_dir == E_DIR.left:
		return a.grid_pos.x < b.grid_pos.x
	elif cur_dir == E_DIR.right:
		return a.grid_pos.x > b.grid_pos.x
	elif cur_dir == E_DIR.up:
		return a.grid_pos.y < b.grid_pos.y
	else:
		return a.grid_pos.y > b.grid_pos.y
