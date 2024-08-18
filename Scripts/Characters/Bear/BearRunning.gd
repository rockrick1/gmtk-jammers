extends State

@export var bear : BaseAnimal

var direction

func enter(_params: Dictionary):
	$StopTimer.start()
	var rand_angle = randf_range(0, 2 * PI)
	direction = Vector3(sin(rand_angle), 0, cos(rand_angle))
	bear.rotation.y = rand_angle + PI
	bear.animation_tree.set("parameters/IW/blend_amount", 1.0)

func physics_process(delta):
	bear.velocity.x = direction.x * bear.cc.run_speed
	bear.velocity.z = direction.z * bear.cc.run_speed
	
	bear.animation_tree.set("parameters/IW/blend_amount", lerp(bear.animation_tree.get("parameters/IW/blend_amount"), 1.0, delta * .3))
	super.physics_process(delta)

func _on_stop_timer_timeout() -> void:
	transitioned.emit(self, "idle")
