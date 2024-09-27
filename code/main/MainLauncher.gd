extends Node

var UIRoot: Node

func _ready() -> void:
	init_ui_root()
	open_menu()
	
func init_ui_root():
	UIRoot = get_node("UIRoot")
	for i in range(10):
		var layer = CanvasLayer.new()
		layer.name = "layer{0}".format([i])
		UIRoot.add_child(layer)

func open_menu():
	const LAUNCH_MENU = preload("res://code/main/LaunchMenu.tscn")
	var menu = LAUNCH_MENU.instantiate()
	var canvs = UIRoot.get_child(5)
	canvs.add_child(menu)
