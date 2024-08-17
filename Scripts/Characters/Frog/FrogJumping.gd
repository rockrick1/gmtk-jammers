extends State

@export var frog: BaseAnimal
@export var impulse: float

func enter(_params: Dictionary):
	_jump()
	frog.animation_tree.set("parameters/IJ/blend_amount", 1)

func _jump():
	var rand_angle = randf_range(0, 2 * PI)
	var vector = Vector3(sin(rand_angle), 1.5, cos(rand_angle)) * impulse
	frog.rotation.y = rand_angle
	frog.velocity += vector

func _physics_process(delta: float) -> void:
	if frog.is_on_floor():
		transitioned.emit(self, "idle")
