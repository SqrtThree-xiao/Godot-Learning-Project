extends Node
class_name UIManger

var UI_PATH:Dictionary = {
	["LAUNCH_MENU"]: {
		"res":"res://code/main/LaunchMenu.tscn",
		"layer" : 3
	}
}
var ui_dict:Dictionary = {}

func _ready() -> void:
	pass # Replace with function body.

func open(name: String) -> bool:
	#if UI_PATH.find_key(name):
	var config = UI_PATH[name]
	var res = load(config.res)
	var ui_root = get_node("MainLauncher/UIRoot")
	var ui = res.instantiate()
	var canvs = ui_root.get_child(config.layer)
	canvs.add_child(ui)
		#return true
	return false
