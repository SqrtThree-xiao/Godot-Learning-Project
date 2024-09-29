extends CharacterBody2D

var com_move:ComonentMove

var point = [
	Vector2i(6, 4), Vector2i(16, 10), Vector2i(11, 10)
]

func _ready() -> void:
	com_move = ComonentMove.new(self, {speed = 100})
	com_move.end_move_signal.connect(on_end_move)


func _process(delta: float) -> void:
	if com_move != null : com_move._process(delta)

func _physics_process(delta: float) -> void:
	if com_move != null : com_move._physics_process(delta)

func on_end_move(node2d, _end_pos):
	if node2d.get_instance_id() != get_instance_id(): return

	var astar_grid = get_parent().astar_grid
	var terrain:TileMapLayer = get_parent().terrain
	var indx = randi() % point.size()
	var l_pos = terrain.to_local(position)
	var character_pos = terrain.local_to_map(l_pos)
	print("on_end_move", character_pos, point[indx])
	var point_path = astar_grid.get_point_path(character_pos, point[indx])
	com_move.to_move(terrain, point_path)
