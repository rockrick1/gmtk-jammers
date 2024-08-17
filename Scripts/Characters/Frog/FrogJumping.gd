
extends State

@export var frog: BaseAnimal
@export var impulse: float

func enter(_params: Dictionary):
	_jump()

func _jump():
	var rand_angle = randf_range(0, 2 * PI)
	var vector = Vector3(cos(rand_angle), 1.5, sin(rand_angle)) * impulse
	frog.velocity += vector

func _physics_process(delta: float) -> void:
	if frog.is_on_floor():
		transitioned.emit(self, "idle")
