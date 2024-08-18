extends BaseAnimal

func _physics_process(delta):
	look_at(player.global_position)
	
	if not $Cooldown.is_stopped():
		return
	
	_check_for_attack()
	
	animation_tree.set("parameters/IW/blend_amount", 1.0)
	
	var direction = global_position.direction_to(player.global_position)
	
	velocity.x = direction.x * cc.run_speed
	velocity.z = direction.z * cc.run_speed
	
	apply_floor_snap()
	move_and_slide()

func _check_for_attack():
	for body in $DamageArea.get_overlapping_bodies():
		if body is not Player:
			continue
		
		$Cooldown.start()
		$AttackTimer.start()
		animation_tree.set("parameters/Attack_One/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		animation_tree.set("parameters/IW/blend_amount", 0.0)
		return

func _on_attack_timer_timeout() -> void:
	for body in $DamageArea.get_overlapping_bodies():
		if body is not Player:
			continue
		
		body.cc.take_damage(cc.base_damage)
