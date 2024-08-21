extends Node


func _on_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	body.cc.take_damage(INF)
