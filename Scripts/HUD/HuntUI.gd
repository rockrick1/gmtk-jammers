extends Control

@export var player : Player

@onready var width := custom_minimum_size.y

var speed := 100
var going_back := false

func _ready():
	pass

func _process(delta: float) -> void:
	var change = delta * speed
	if $ProgressBar.value + change > 100:
		going_back = true
	elif $ProgressBar.value - change < 0:
		going_back = false
	if going_back:
		change *= -1
	$ProgressBar.value += change

func stop():
	pass
