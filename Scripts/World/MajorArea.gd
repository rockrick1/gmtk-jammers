extends Area3D

@export var id : int
@export var size_boost : float
@export var new_arm_length : float
@export var spring_arm_pivot : SpringArmPivot

func _ready():
	pass

func _on_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	
	body.enter_major_area(id, size_boost, new_arm_length)
