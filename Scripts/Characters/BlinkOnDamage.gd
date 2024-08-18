class_name BlinkOnDamage
extends Node

@export var cc : CharacterComponent

func _ready():
	get_parent().visible = false
	cc.damaged.connect(_on_damaged)

func _on_damaged(amount: float):
	get_parent().visible = true
	$Timer.start()

func _on_timer_timeout() -> void:
	get_parent().visible = false
