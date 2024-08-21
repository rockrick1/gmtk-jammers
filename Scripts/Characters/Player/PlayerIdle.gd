extends PlayerMovementState

func enter(_params: Dictionary):
	player.velocity = Vector3.ZERO

func physics_process(delta):
	var wants_jump := Input.is_action_just_pressed("jump")
	var is_on_floor := player.is_on_floor()
	if wants_jump or not is_on_floor:
		var params := PlayerAirborneState.Params.new()
		if wants_jump and player.cc.abilities.has(Ability.Type.FrogJump):
			params.jump_force = Vector3.UP * cc.jump_strength * player.scale.x * .65
		transitioned.emit(self, "airborne", { airborne_params = params })
		super.physics_process(delta)
		return
	
	var move_direction = get_movement_direction()
	
	player.velocity *= Vector3.UP
	player.velocity.y -= player.gravity * delta * 0.3
	
	if move_direction != Vector3.ZERO:
		transitioned.emit(self, "running")

	animator.set("parameters/IWJ/blend_amount", lerp(animator.get("parameters/IWJ/blend_amount"), 0.0, delta * player.ANIMATION_BLEND))
	super.physics_process(delta)
