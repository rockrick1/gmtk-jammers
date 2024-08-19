class_name SpringArmPivot
extends Node3D

const SCALE_ANIMATION_TIME = 3

@export var player : Player

var size_thresholds = [1, 5, 50, INF]
var current_threshold_index := 0
var current_threshold : int:
	get:
		return size_thresholds[current_threshold_index]
var next_threshold : int:
	get:
		return size_thresholds[current_threshold_index + 1]
var base_length : float
var current_length : float
var original_line_thickness : float

func _ready():
	current_length = $SpringArm3D.spring_length
	base_length = $SpringArm3D.spring_length

func _physics_process(delta: float) -> void:
	global_position = player.global_position

func change_size(current_size: Vector3):
	if (current_size.x > next_threshold):
		current_threshold_index += 1
	
	current_length = base_length * (current_size.x ** .8)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($SpringArm3D, "spring_length", current_length, SCALE_ANIMATION_TIME)
	
	var new_thickness = 1 / (current_length / 20)
	print(1 + new_thickness)
	$SpringArm3D/Camera3D/MeshInstance3D.material_override.set("shader_param/shadow_thickness", 1 + new_thickness );
