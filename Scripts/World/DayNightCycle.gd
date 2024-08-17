extends Node

@export var cycle_time : float

var current_time : float
var is_day : bool:
	get:
		return current_time < PI

func _ready() -> void:
	current_time = 0

func _process(delta: float) -> void:
	_update_time(delta)
	$SunlightPivot.rotation.x = current_time

func _update_time(delta: float):
	current_time += delta * 2 * PI / cycle_time
	if current_time > 2 * PI:
		current_time = 0
	
