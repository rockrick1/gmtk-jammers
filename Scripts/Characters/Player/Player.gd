class_name Player
extends CharacterBody3D

const LERP_VALUE : float = 0.25
const ANIMATION_BLEND : float = 7

@export var gravity : float = 50.0

@onready var character_component := $CharacterComponent
@onready var spring_arm_pivot := $SpringArmPivot
@onready var mesh : Node3D = $Mesh
@onready var animator := $AnimationTree
@onready var movement_state_machine := $MovementStateMachine

var cc : CharacterComponent:
	get:
		return character_component
var snap_vector : Vector3 = Vector3.DOWN
var h_speed : float

func _ready():
	pass
	#cc.died.connect(_on_died)
	#primary_weapon.shot_fired.connect(_on_primary_shot_fired)
	#secondary_weapon.shot_fired.connect(_on_secondary_shot_fired)
	movement_state_machine.initialize()

func _process(_delta):
	pass
	#if Input.is_key_pressed(KEY_1):
		#secondary_weapon.shot_fired.disconnect(_on_secondary_shot_fired)
		#secondary_weapon = $Bazooka
		#secondary_weapon.shot_fired.connect(_on_secondary_shot_fired)
	#if Input.is_key_pressed(KEY_2):
		#secondary_weapon.shot_fired.disconnect(_on_secondary_shot_fired)
		#secondary_weapon = $Grapple
		#secondary_weapon.shot_fired.connect(_on_secondary_shot_fired)

#func get_weapon_target_vector() -> Vector3:
	#var target : Vector3
	#if weapon_ray.is_colliding() and (weapon_ray.get_collision_point() - weapon_ray.global_transform.origin).length() > 0.2:
		#target = weapon_ray.get_collision_point()
	#else:
		#target = (weapon_ray.target_position.z * weapon_ray.global_transform.basis.z) + weapon_ray.global_transform.origin
	#return target

#func _on_primary_shot_fired():
	#primary_weapon.spawn_projectiles(right_weapon_tip.global_position, get_weapon_target_vector())
	#right_weapon_ik.startIK()
#
#func _on_secondary_shot_fired():
	#secondary_weapon.spawn_projectiles(left_weapon_tip.global_position, get_weapon_target_vector())
	#left_weapon_ik.startIK()

func _on_died():
	print("YOU DIED!!!")
