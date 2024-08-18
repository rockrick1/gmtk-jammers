extends State

@export var gnome : BaseAnimal
@export var min_interval: float
@export var max_interval: float

func enter(_params: Dictionary):
	gnome.player_entered.connect(_on_player_entered)
	$RunTimer.wait_time = randf_range(min_interval, max_interval)
	$RunTimer.start()
	gnome.velocity = Vector3.ZERO
	gnome.animation_tree.set("parameters/IW/blend_amount", 0)

func _on_run_timer_timeout() -> void:
	transitioned.emit(self, "running")

func exit():
	$RunTimer.stop()
	gnome.player_entered.disconnect(_on_player_entered)

func _on_player_entered():
	transitioned.emit(self, "followingplayer")
