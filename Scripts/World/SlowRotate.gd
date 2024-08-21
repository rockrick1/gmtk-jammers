extends Node3D

func _physics_process(delta: float) -> void:
	rotation.y += delta * .2
