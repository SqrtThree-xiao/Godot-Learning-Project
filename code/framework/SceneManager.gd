extends Node

var pool: Dictionary
var scene_map = {}

var loadding_path = null

func _ready() -> void:
	var canvas_layer = CanvasLayer.new()
	canvas_layer.name = "layer1"
	add_child(canvas_layer)

func get_scene_config(key: String):
	var file = FileAccess.open("res://tables/SceneConfig.json", FileAccess.READ)
	var file_content = file.get_as_text()
	var json_parse_result = JSON.parse_string(file_content)
	var config = json_parse_result[key]
	return config

func load_scene(scene_name: String) -> void:
	var config = get_scene_config(scene_name)
	scene_map[scene_name] = {}
	scene_map[scene_name].name = scene_name
	scene_map[scene_name].res_path = config.res
	scene_map[scene_name].is_loaded = false
	ResourceLoader.load_threaded_request(config.res)

func _process(_delta: float) -> void:
	check_loaded()
	
func check_loaded() -> void:
	for scene_name in scene_map:
		var scene_info = scene_map[scene_name]
		if not scene_info.is_loaded:
			var status = ResourceLoader.load_threaded_get_status(scene_info.res_path)
			if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
				scene_info.is_loaded = true
				var resource = ResourceLoader.load_threaded_get(scene_info.res_path)
				scene_map[scene_name].node = resource.instantiate()
				load_loaded(scene_map[scene_name].node)

func load_loaded(node: Node2D) -> void:
	get_child(0).add_child(node)

func enter_scene(scene_name: String) -> void:
	load_scene(scene_name)

func exit_scene(scene_name: String) -> void:
	if not scene_map.has(scene_name): return
	var scene_info = scene_map[scene_name]
	if scene_info.is_loaded:
		scene_info.node.free()
		scene_map.erase(scene_name)
