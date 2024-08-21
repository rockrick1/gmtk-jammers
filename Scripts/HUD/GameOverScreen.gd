extends Control

func _ready() -> void:
	visible = false

func open(text: String, score: int):
	$"../SkillsUI".visible = false
	$"../HuntUI".visible = false
	visible = true
	$Panel/VBoxContainer/Label.text = text
	$Panel/VBoxContainer/Score.text = "Animals consumed: " + str(score)
	get_tree().paused = true

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
