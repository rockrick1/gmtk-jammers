extends PlayerMovementState

@export var air_control : float
@export var gravity : float

var just_entered : bool

func enter(params: Dictionary):
	#animator.set("parameters/ground_air_transition/transition_request", "air")
	player.snap_vector = Vector3.ZERO
	
	just_entered = true

func physics_process(delta):
	var move_direction = get_movement_direction()
	
	if not Input.is_action_pressed("jump"):
		var params := PlayerAirborneState.Params.new()
		transitioned.emit(self, "airborne", { airborne_params = params })
		super.physics_process(delta)
		return
	
	player.velocity.y = -gravity * delta
	
	var h_speed := cc.run_speed
	player.velocity.x = lerp(player.velocity.x, move_direction.x * h_speed, delta * air_control)
	player.velocity.z = lerp(player.velocity.z, move_direction.z * h_speed, delta * air_control)
	
	if move_direction and not player.looking_at_cursor:
		player.update_rotation(true)
	
	if player.is_on_floor() and not just_entered:
		player.snap_vector = Vector3.DOWN
		
		if move_direction == Vector3.ZERO:
			transitioned.emit(self, "idle")
		else:
			transitioned.emit(self, "running")
	
	just_entered = false
	
	animator.set("parameters/IWJ/blend_amount", lerp(animator.get("parameters/IWJ/blend_amount"), -1.0, delta * player.ANIMATION_BLEND))
	
	super.physics_process(delta)
