extends Control

func _ready() -> void:
	visible = false

func open():
	visible = true
	get_tree().paused = true

func close():
	visible = false
	get_tree().paused = false

func _on_resume_pressed() -> void:
	close()

func _on_retry_pressed() -> void:
	close()
	get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not visible:
			open()
		elif visible:
			close()
