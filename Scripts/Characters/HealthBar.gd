extends ProgressBar

@export var player : Player

func _process(delta):
	value = player.cc.current_health
