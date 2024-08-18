extends Node

@export var cycle_time : float

var current_time : float
var is_day : bool:
	get:
		return current_time < PI

func _ready() -> void:
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

func _enter_night():
	_set_spawners_active($"../EnemySpawners".get_children(), false)
	_set_spawners_active($"../AnimalSpawners".get_children(), true)

func _set_spawners_active(spawners: Array[Node], active: bool):
	for spawner in spawners:
		if spawner is not CharacterSpawner:
			continue
		spawner.enabled = active
