extends Node2D

@onready var terrain: TileMapLayer = $terrain


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	init_terrain()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var l_pos = terrain.to_local(event.position)
			var map_pos = terrain.local_to_map(l_pos)
			print(event.position, map_pos)

func init_terrain():
	var astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i()
	print("init_map_pos")
