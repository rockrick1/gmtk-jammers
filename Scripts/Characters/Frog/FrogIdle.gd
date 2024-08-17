extends State

@export var frog: BaseAnimal
@export var min_interval: float
@export var max_interval: float

func enter(_params: Dictionary):
	$JumpTimer.wait_time = randf_range(min_interval, max_interval)
	$JumpTimer.start()
	frog.velocity = Vector3.ZERO
	frog.animation_tree.set("parameters/IJ/blend_amount", 0)

func _on_jump_timer_timeout() -> void:
	transitioned.emit(self, "jumping")
