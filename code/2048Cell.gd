extends Control

@export var grid_pos: Vector2i = Vector2i.ZERO
@export var number: int = 2
@onready var label: Label = $Label
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var control: Control = $"."

var tween
var color_dict = {
	2: Color.WHITE,
	2 << 1: Color("90646c"),
	2 << 2: Color.AQUA,
	2 << 3: Color.AQUAMARINE,
	2 << 4: Color.BEIGE,
	2 << 5: Color.BISQUE,
	2 << 6: Color.BLUE,
	2 << 7: Color.BLUE_VIOLET,
	2 << 8: Color.BROWN,
	2 << 9: Color.REBECCA_PURPLE,
	2 << 10: Color.VIOLET,
	2 << 11: Color.CADET_BLUE,
	2 << 12: Color.DARK_GOLDENROD,
	2 << 13: Color.DEEP_PINK,
	2 << 14: Color.WEB_GREEN,
}

func _ready() -> void:
	refresh_view(grid_pos, number)
	appear()

func refresh_view(new_grid_pos, new_number):
	label.text = String.num(number)
	grid_pos = new_grid_pos
	position = grid_pos * 64
	number = new_number
	nine_patch_rect.modulate = color_dict[number]

func appear():
	if tween != null:
		tween.kill()
	scale = Vector2.ZERO
	tween = create_tween().set_ease(Tween.EaseType.EASE_OUT)
	tween.tween_property(control, "scale", Vector2.ONE, 0.2)

func disappear(pos):
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(control, "position", pos, 0.2)
	tween.tween_callback(free)

func move(pos):
	tween = create_tween()
	tween.tween_property(control, "position", pos, 0.2)
