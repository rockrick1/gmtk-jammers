extends AudioStreamPlayer2D

@onready var character_component = $"../CharacterComponent"


func _ready():
	character_component.damaged.connect(_on_signal)
	
func _on_signal(amount: int):
	play()
