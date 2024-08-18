extends Ability

var player : Player

func _ready():
	$GPUParticles3D.emitting = false
	player.ability_released.connect(_on_ability_released)
	
	await get_tree().create_timer(.1)
	$GPUParticles3D.emitting = true

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		return
	if not body.has_node("CharacterComponent"):
		return
	body.get_node("CharacterComponent").take_damage(level)

func _on_ability_released():
	queue_free()
