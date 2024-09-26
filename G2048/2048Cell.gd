extends Node

@export var grid_pos : Vector2i = Vector2i.ZERO
@export var number : int = 2
@onready var label: Label = $Label

func _ready() -> void:
	self.position = grid_pos * 64
	label.text = String.num(number) 

func refresh_view(new_pos, new_number) -> void:
	grid_pos = new_pos
	number = new_number

	self.position = grid_pos * 64
	label.text = String.num(number) 
