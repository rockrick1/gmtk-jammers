extends Ability

var player : Player

func _ready():
	player.ability_released.connect(_on_ability_released)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		return
	if not body.has_node("CharacterComponent"):
		return
	body.get_node("CharacterComponent").take_damage(level * 2)

func _on_ability_released():
	queue_free()
