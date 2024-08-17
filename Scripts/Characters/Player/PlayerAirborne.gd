class_name PlayerAirborneState
extends PlayerMovementState

@export var air_control : float

var just_entered : bool

func enter(params: Dictionary):
	player.snap_vector = Vector3.ZERO
	just_entered = true
	player.velocity += params.airborne_params.jump_force

func physics_process(delta):
	var move_direction = get_movement_direction()
	
	player.velocity.y -= player.gravity * delta
	
	var h_speed := cc.run_speed
	player.velocity.x = lerp(player.velocity.x, move_direction.x * h_speed, delta * air_control)
	player.velocity.z = lerp(player.velocity.z, move_direction.z * h_speed, delta * air_control)
	
	if player.cc.abilities.has(Ability.Type.DuckGlide) and Input.is_action_pressed("jump") and player.velocity.y < 0:
		transitioned.emit(self, "gliding")
		super.physics_process(delta)
		return
		
	if move_direction and not player.looking_at_cursor:
		player.update_rotation()
	
	if player.is_on_floor() and not just_entered:
		player.snap_vector = Vector3.DOWN
		
		if move_direction == Vector3.ZERO:
			transitioned.emit(self, "idle")
		else:
			transitioned.emit(self, "running")
	
	just_entered = false
	
	animator.set("parameters/IWJ/blend_amount", lerp(animator.get("parameters/IWJ/blend_amount"), -1.0, delta * player.ANIMATION_BLEND))
	
	super.physics_process(delta)

class Params:
	var jump_force : Vector3 = Vector3.ZERO
