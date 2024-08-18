class_name CharacterComponent
extends Node

signal stats_updated
signal damaged(amount: int)
signal died
signal ability_unlocked(ability: Ability.Type)

@export var base_health := 15.0
@export var base_run_speed := 5.0
@export var base_jump_strength := 15.0
@export var base_damage := 15.0

@onready var character : PhysicsBody3D = get_parent()
@onready var current_health := base_health

var _max_health_buff : float
var _speed_buff : float
var _damage_buff : float
var _attack_speed_buff : float

var _abilities_to_scroll := [
	Ability.Type.MantisSlash,
	Ability.Type.CrabJet,
	Ability.Type.BearStomp,
	Ability.Type.DragonBreath
]

var available_abilities_to_scroll : Array[Ability.Type] = []
var abilities := {}
var size := Vector3.ONE
var invinicility_timer : Timer = null

var max_health : float:
	get:
		return base_health + _max_health_buff
var run_speed : float:
	get:
		return base_run_speed * _speed_buff * size.x
var jump_strength : float:
	get:
		return base_jump_strength * (abilities[Ability.Type.FrogJump] ** .05)

func _ready():
	invinicility_timer = Timer.new()
	invinicility_timer.wait_time = .2
	invinicility_timer.one_shot = true
	invinicility_timer.autostart = false
	add_child(invinicility_timer)
	reset_stats()

func reset_stats():
	_max_health_buff = 0
	_speed_buff = 1.0
	_damage_buff = 1.0
	_attack_speed_buff = 1.0
	apply_new_stats()

func add_ability(ability: Ability.Type):
	if not abilities.has(ability):
		if ability in _abilities_to_scroll:
			available_abilities_to_scroll.append(ability)
		abilities[ability] = 0
		ability_unlocked.emit(ability)
	abilities[ability] += 1
	
	apply_new_stats()

func apply_new_stats():
	stats_updated.emit()

func take_damage(amount: float):
	if not invinicility_timer.is_stopped():
		return
	
	invinicility_timer.start()
	current_health -= amount
	damaged.emit(amount)
	if current_health <= 0:
		died.emit()

func heal(amount: float):
	amount = min(amount, max_health - current_health)
	if amount == 0:
		return
	
	current_health += amount
