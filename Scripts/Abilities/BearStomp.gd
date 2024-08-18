extends Ability

func _ready() -> void:
	await get_tree().create_timer(.4)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		return
	if not body.has_node("CharacterComponent"):
		return
	body.get_node("CharacterComponent").take_damage(level)

func _on_life_timer_timeout() -> void:
	queue_free()
