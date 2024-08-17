class_name CharacterComponent
extends Node

signal stats_updated
signal damaged(int)
signal died

@export var base_health := 15.0
@export var base_run_speed := 5.0
@export var base_jump_strength := 15.0
@export var base_damage := 15.0

@onready var character : PhysicsBody3D = get_parent()
@onready var current_health := base_health
@onready var heal_cooldown := $HealCooldown
@onready var heal_timer := $HealTimer

var _max_health_buff : float
var _speed_buff : float
var _damage_buff : float
var _attack_speed_buff : float

var abilities := {}

var max_health : float:
	get:
		return base_health + _max_health_buff
var run_speed : float:
	get:
		return base_run_speed * _speed_buff
var jump_strength : float:
	get:
		return base_jump_strength + (abilities[Ability.Type.FrogJump] / 3)

func _ready():
	reset_stats()

func reset_stats():
	_max_health_buff = 0
	_speed_buff = 1.0
	_damage_buff = 1.0
	_attack_speed_buff = 1.0
	apply_new_stats()

func add_ability(ability: Ability.Type):
	if not abilities.has(ability):
		abilities[ability] = 0
	abilities[ability] += 1
	
	apply_new_stats()

func apply_new_stats():
	stats_updated.emit()

func take_damage(amount: float, push_force: Vector3 = Vector3.ZERO):
	current_health -= amount
	heal_timer.stop()
	heal_cooldown.start()
	
	damaged.emit(amount)
	
	#if character is RigidBody3D:
		#character.apply_force(push_force)
	#elif character is CharacterBody3D:
		#character.snap_vector = Vector3.ZERO
		#character.velocity = push_force
	
	if current_health <= 0:
		died.emit()

func heal(amount: float):
	amount = min(amount, max_health - current_health)
	if amount == 0:
		return
	
	current_health += amount

func _on_heal_cooldown_timeout():
	heal_timer.start()

func _on_heal_timer_timeout():
	heal(1)
