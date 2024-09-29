extends Node2D

@onready var terrain: TileMapLayer = $terrain
@onready var character: CharacterBody2D = $"角色"
@onready var character2: CharacterBody2D = $"角色2"

var astar_grid: AStarGrid2D = AStarGrid2D.new()

func _ready() -> void:
	init_terrain()
	to_move(character, Vector2i(6, 4))
	to_move(character2, Vector2i(6, 4))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print(event.position)
			#var l_pos = terrain.to_local(event.position)
			#var map_pos = terrain.local_to_map(l_pos)
			#l_pos = terrain.to_local(character.position)
			#var character_pos = terrain.local_to_map(l_pos)
			#var point_path = astar_grid.get_point_path(character_pos, map_pos)
			#character.com_move.to_move(terrain, point_path)

func init_terrain():
	var cells = terrain.get_used_cells()
	var left_up: Vector2i = Vector2i.ZERO
	var right_down: Vector2i = Vector2i.ZERO

	for i in range(cells.size()):
		var cell = cells[i]
		if i == 0:
			left_up = cell
			right_down = cell
		else:
			left_up.x = left_up.x if left_up.x < cell.x else cell.x
			left_up.y = left_up.y if left_up.y < cell.y else cell.y
			
			right_down.x = right_down.x if right_down.x > cell.x else cell.x
			right_down.y = right_down.y if right_down.y > cell.y else cell.y

	astar_grid.region = Rect2i(left_up.x, left_up.y, right_down.x, right_down.y)
	astar_grid.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES)
	astar_grid.update()
	for x in range(left_up.x, right_down.x, 1):
		for y in range(left_up.y, right_down.y, 1):
			var code = terrain.get_cell_source_id(Vector2i(x, y))
			if code == -1:
				astar_grid.set_point_solid(Vector2i(x, y))

func to_move(_character:CharacterBody2D, point:Vector2i):
	var l_pos = terrain.to_local(_character.position)
	var character_pos = terrain.local_to_map(l_pos)
	var point_path = astar_grid.get_point_path(character_pos, point)
	_character.com_move.to_move(terrain, point_path)
