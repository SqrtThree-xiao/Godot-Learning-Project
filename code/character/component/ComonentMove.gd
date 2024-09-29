class_name ComonentMove
extends ComponentBase

enum move_state {moving, stop}

var cur_state: move_state = move_state.stop
var points: PackedVector2Array
var speed: float = 100.0
var terrain: TileMapLayer

signal end_move_signal(owner:Node2D, end_point:Node2D)

func _init(_owner, _data):
	owner = _owner
	speed = _data.speed

func _physics_process(delta: float) -> void:
	if cur_state == move_state.stop: return
	if not on_move(delta): end_move()

func to_move(_terrain:TileMapLayer, _points: PackedVector2Array, ):
	cur_state = move_state.moving
	terrain = _terrain
	points = _points

func on_move(delta) -> bool:
	if points.size() == 0:
		end_move()
		return false
	
	var point = points[0]
	var pos = terrain.map_to_local(point)
	var g_pos = terrain.to_global(pos)

	if g_pos.distance_squared_to(owner.position) > 10:
		var dir = (g_pos - owner.position).normalized()
		owner.position += dir * speed * delta
	else:
		points.remove_at(0)
	return true

func end_move():
	cur_state = move_state.stop
	var pos = terrain.to_local(owner.position)
	var grid_pos = terrain.local_to_map(pos)
	end_move_signal.emit(owner, grid_pos)
