extends PlayerMovementState

func enter(_params: Dictionary):
	pass

func physics_process(delta):
	var wants_jump := Input.is_action_just_pressed("jump")
	var can_jump : bool = player.cc.abilities.has(Ability.Type.FrogJump)
	var is_on_floor := player.is_on_floor()
	if (wants_jump or not is_on_floor) and can_jump:
		var params := PlayerAirborneState.Params.new()
		if wants_jump:
			params.jump_force = Vector3.UP * cc.jump_strength * player.scale.x * .65
		transitioned.emit(self, "airborne", { airborne_params = params })
		super.physics_process(delta)
		return
	
	var move_direction = get_movement_direction()
	
	player.velocity.y -= player.gravity * delta * 0.3

	var h_speed := cc.run_speed
	player.velocity.x = move_direction.x * h_speed
	player.velocity.z = move_direction.z * h_speed
	
	if move_direction and not player.looking_at_cursor:
		player.update_rotation()
	
	if move_direction == Vector3.ZERO:
		transitioned.emit(self, "idle")
	
	animator.set("parameters/IWJ/blend_amount", lerp(animator.get("parameters/IWJ/blend_amount"), 1.0, delta * player.ANIMATION_BLEND))
	super.physics_process(delta)
