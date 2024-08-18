extends State

@export var crab : BaseAnimal

var direction

func enter(_params: Dictionary):
	$StopTimer.start()
	var rand_angle = randf_range(0, 2 * PI)
	direction = Vector3(sin(rand_angle), 0, cos(rand_angle))
	crab.rotation.y = rand_angle + PI
	crab.animation_tree.set("parameters/IW/blend_amount", 1.0)

func physics_process(delta):
	crab.velocity.x = direction.x * crab.cc.run_speed
	crab.velocity.z = direction.z * crab.cc.run_speed
	
	crab.animation_tree.set("parameters/IW/blend_amount", lerp(crab.animation_tree.get("parameters/IW/blend_amount"), 1.0, delta * .3))
	super.physics_process(delta)

func _on_stop_timer_timeout() -> void:
	transitioned.emit(self, "idle")
