extends Node2D

@onready var select_box: TileMapLayer = $"选中框"
var coords = Vector2.ZERO

func _input(event: InputEvent) -> void:
	draw_select_box(event)

func draw_select_box(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_double_click():
			select_box.erase_cell(coords)
			var pos = get_global_mouse_position()
			var local_pos = select_box.to_local(pos)
			coords = select_box.local_to_map(local_pos)
			select_box.set_cell(coords, 1, Vector2i(3, 0))
