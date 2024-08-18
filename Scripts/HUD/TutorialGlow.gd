extends CanvasItem

@export var player : AnimationPlayer

func _ready():
	visible = false
	pass

func show_glow():
	player.play("glow")
