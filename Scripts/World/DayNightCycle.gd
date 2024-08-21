extends Node

@export var cycle_time : float
@export var player : Player
@export var second_major_area_spawners : Array[CharacterSpawner]
@export var third_major_area_spawners : Array[CharacterSpawner]
@onready var animation_player = $AnimationPlayer

var current_time : float
var is_day : bool:
	get:
		return current_time < PI

func _ready() -> void:
	player.major_area_entered.connect(_on_player_entered_major_area)
	current_time = PI - 0.000001

func _process(delta: float) -> void:
	_update_time(delta)
	$SunlightPivot.rotation.x = current_time

func _update_time(delta: float):
	var previous_time = current_time
	current_time += delta * 2 * PI / cycle_time
	if current_time > 2 * PI:
		current_time = 0
		_enter_day()
	
	if current_time > PI and previous_time < PI:
		_enter_night()

func _enter_day():
	_set_spawners_active($"../EnemySpawners".get_children(), true)
	_set_spawners_active($"../AnimalSpawners".get_children(), false)
	animation_player.play("DayLabel")

func _enter_night():
	_set_spawners_active($"../EnemySpawners".get_children(), false)
	_set_spawners_active($"../AnimalSpawners".get_children(), true)
	animation_player.play("RESET")
	animation_player.play("NightLabel")

func _set_spawners_active(spawners: Array[Node], active: bool):
	for spawner in spawners:
		if spawner is not CharacterSpawner:
			continue
		
		spawner.enabled = active
		
		if active:
			continue
		
		for child in spawner.get_children():
			if child is not BaseAnimal:
				continue
			child.queue_free()

func _on_player_entered_major_area(id: int):
	var spawners : Array[CharacterSpawner]
	if id == 0:
		spawners = second_major_area_spawners
	else:
		spawners = third_major_area_spawners
	
	for spawner in spawners:
		spawner.enabled_override = true
	
	if is_day:
		_set_spawners_active($"../EnemySpawners".get_children(), true)
		_set_spawners_active($"../AnimalSpawners".get_children(), false)
	else:
		_set_spawners_active($"../EnemySpawners".get_children(), false)
		_set_spawners_active($"../AnimalSpawners".get_children(), true)
