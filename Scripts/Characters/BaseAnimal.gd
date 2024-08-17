class_name BaseAnimal
extends CharacterBody3D

const GRAVITY := 50

@export var ability : Ability.Type
@export var size_value : float

@onready var cc := $CharacterComponent

func consume():
	queue_free()

func _physics_process(delta: float) -> void:
	velocity.y -= GRAVITY * delta
	
	apply_floor_snap()
	move_and_slide()
