extends WindowBase
@export var quit:Button

func _init() -> void:
	SceneManager.enter_scene("nav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quit.pressed.connect(on_click_quit)

func on_click_quit() -> void:
	on_click_close()
	SceneManager.exit_scene("nav")
	UIManger.open_ui(Const.UI_NAME.LaunchMenu)
