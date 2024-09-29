extends WindowBase

@export var btn2048: Button = null
@export var quit: Button = null
@export var nav: Button = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn2048.pressed.connect(_on_click_2048)
	quit.pressed.connect(_on_click_quit)
	nav.pressed.connect(_on_click_nav)

func _on_click_quit() -> void:
	get_tree().quit()
	
func _on_click_2048() -> void:
	on_click_close()
	UIManger.open_ui(Const.UI_NAME.G2048)
	
func _on_click_nav() -> void:
	on_click_close()
	UIManger.open_ui(Const.UI_NAME.Nav)
