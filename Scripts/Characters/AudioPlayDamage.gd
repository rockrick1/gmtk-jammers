extends AudioStreamPlayer2D

@onready var character_component = $"../CharacterComponent"
@onready var audio_stream_player_2d = $"."


func _ready():
	character_component.damaged.connect(_on_signal)
	
func _on_signal(amount: int):
	audio_stream_player_2d.play()
