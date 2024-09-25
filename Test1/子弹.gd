extends Node2D

var Speed = 100
var b_dir = Vector2.UP
var b_pos = Vector2.ZERO

func _ready() -> void:
	position = b_pos

func _process(delta: float) -> void:
	position += delta * Speed * b_dir

func set_params(pos, dir):
	b_dir = dir
	b_pos = pos
