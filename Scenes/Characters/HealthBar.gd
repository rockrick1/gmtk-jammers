extends ProgressBar


@onready var cc = $"../CharacterComponent"
@onready var hurt = $"../Hurt"

func _ready():
	value = cc.base_health
	cc.audio_queue.connect(_on_audio_queue)

func _process(delta):
	value = cc.current_health
	
func _on_audio_queue():
	hurt.play()
