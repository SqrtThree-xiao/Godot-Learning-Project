extends Node

const max_layer:int = 10
var windows = {}
var ui_config = preload("res://tables/UIConfig.tres").data

func _ready() -> void:
	init_ui_root()
	open_ui(Const.UI_NAME.LaunchMenu)
	
func open_ui(id:int) -> void:
	var config = ui_config[str(id)]
	var window = null
	if windows.find_key(id):
		window = windows.get(id)
	else:
		window = load(config.res).instantiate()
		window.name = config.name
		windows[id] = window
	
	window._init_config({id = id})
	var node = get_child(config.layer)
	node.add_child(window)

func close_ui(id:int) -> void:
	var window = windows.get(id)
	window.queue_free()
	windows.erase(id)

func init_ui_root():
	for i in range(max_layer):
		var layer = CanvasLayer.new()
		layer.name = "layer{0}".format([i])
		add_child(layer)
