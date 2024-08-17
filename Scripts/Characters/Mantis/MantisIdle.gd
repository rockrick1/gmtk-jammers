extends State

@export var mantis : BaseAnimal
@export var min_interval: float
@export var max_interval: float

func enter(_params: Dictionary):
	$RunTimer.wait_time = randf_range(min_interval, max_interval)
	$RunTimer.start()
	mantis.velocity = Vector3.ZERO
	mantis.animation_tree.set("parameters/IW/blend_amount", 0)

func _on_run_timer_timeout() -> void:
	transitioned.emit(self, "running")
