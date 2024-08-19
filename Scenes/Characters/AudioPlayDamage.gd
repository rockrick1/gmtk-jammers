extends AudioStreamPlayer2D

@onready var character_component = $"../CharacterComponent"
@onready var audio_stream_player_2d = $"."


func _ready():
	character_component.audio_queue.connect(_on_signal)
	
func _on_signal():
	audio_stream_player_2d.play()
