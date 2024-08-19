extends Control

func _ready() -> void:
	visible = false

func open():
	visible = true

func close():
	visible = false

func _on_play_again_pressed() -> void:
	close()
	get_tree().reload_current_scene()
