extends State

@export var gnome : BaseAnimal
@export var distance_to_attack : float

func enter(_params: Dictionary):
	gnome.animation_tree.set("parameters/IW/blend_amount", 1.0)

func physics_process(delta):
	gnome.look_at(gnome.player.position)
	
	var direction = gnome.global_position.direction_to(gnome.player.global_position)
	
	gnome.velocity.x = direction.x * gnome.cc.run_speed
	gnome.velocity.z = direction.z * gnome.cc.run_speed
	
	if (gnome.player.global_position.distance_to(gnome.global_position) < distance_to_attack):
		transitioned.emit(self, "attacking")
	
	super.physics_process(delta)
