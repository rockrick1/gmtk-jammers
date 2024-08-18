extends State

signal attacked

@export var gnome : BaseAnimal

func enter(_params: Dictionary):
	$Cooldown.start()
	$AttackTimer.start()
	gnome.animation_tree.set("parameters/Attack_One/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	gnome.animation_tree.set("parameters/IW/blend_amount", 0.0)

func physics_process(delta):
	gnome.look_at(gnome.player.position)
	super.physics_process(delta)

func _on_attack_timer_timeout() -> void:
	attacked.emit()

func _on_cooldown_timeout() -> void:
	transitioned.emit(self, "followingplayer")
