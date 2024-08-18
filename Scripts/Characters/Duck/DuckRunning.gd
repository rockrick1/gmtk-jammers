extends State

@export var duck : BaseAnimal
@export var speed : float

var direction

func enter(_params: Dictionary):
	$StopTimer.start()
	var rand_angle = randf_range(0, 2 * PI)
	direction = Vector3(sin(rand_angle), 0, cos(rand_angle))
	duck.rotation.y = rand_angle + PI
	duck.animation_tree.set("parameters/IW/blend_amount", 1.0)

func physics_process(delta):
	duck.velocity.x = direction.x * speed
	duck.velocity.z = direction.z * speed
	
	duck.animation_tree.set("parameters/IW/blend_amount", lerp(duck.animation_tree.get("parameters/IW/blend_amount"), 1.0, delta * .3))
	super.physics_process(delta)

func _on_stop_timer_timeout() -> void:
	transitioned.emit(self, "idle")
