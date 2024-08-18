class_name BaseAnimal
extends CharacterBody3D

const GRAVITY := 50

signal player_entered
signal player_exited

@export var ability : Ability.Type
@export var size_value : float

@onready var cc : CharacterComponent = $CharacterComponent
@onready var animation_tree := $AnimationTree
@onready var player : Player = get_node("/root/Game").player

func _ready():
	var state_machine : StateMachine = get_node("StateMachine")
	if state_machine:
		state_machine.initialize()
	cc.died.connect(_on_died)

func consume():
	queue_free()

func _physics_process(delta: float) -> void:
	velocity.y -= GRAVITY * delta
	
	apply_floor_snap()
	move_and_slide()

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player_entered.emit()

func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player_exited.emit()

func _on_died():
	queue_free()
