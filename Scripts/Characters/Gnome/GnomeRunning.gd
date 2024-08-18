extends State

@export var gnome : BaseAnimal
@export var speed : float

var direction

func enter(_params: Dictionary):
	gnome.player_entered.connect(_on_player_entered)
	$StopTimer.start()
	var rand_angle = randf_range(0, 2 * PI)
	direction = Vector3(sin(rand_angle), 0, cos(rand_angle))
	gnome.rotation.y = rand_angle + PI
	gnome.animation_tree.set("parameters/IW/blend_amount", 1.0)

func physics_process(delta):
	gnome.velocity.x = direction.x * speed
	gnome.velocity.z = direction.z * speed
	
	super.physics_process(delta)

func exit():
	$StopTimer.stop()
	gnome.player_entered.disconnect(_on_player_entered)

func _on_player_entered():
	transitioned.emit(self, "followingplayer")

func _on_stop_timer_timeout() -> void:
	transitioned.emit(self, "idle")
