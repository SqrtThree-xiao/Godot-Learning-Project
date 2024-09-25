extends CharacterBody2D

const SPEED = 300.0

@export var dir:Vector2 = Vector2.UP

func _physics_process(delta: float) -> void:
	var x := Input.get_axis("ui_left", "ui_right")
	var y := Input.get_axis("ui_up", "ui_down")
	if x or y:
		var dir = Vector2(x, y)
		position += dir * SPEED * delta
		
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_accept"):
		attack()

func attack():
	var node = load("res://Test1/子弹.tscn").instantiate()
	node.set_params(position, dir)
	get_parent().add_child(node)
	
