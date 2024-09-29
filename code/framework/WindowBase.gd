class_name WindowBase
extends Control

var uid:int

func _init()->void:
	pass

func _init_config(_data):
	uid = _data.id

func on_click_close()-> void:
	UIManger.close_ui(self.uid)
