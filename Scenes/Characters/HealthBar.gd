extends ProgressBar


@onready var character_component = $"../CharacterComponent"

func _ready():
	value = character_component.base_health
	

func _process(delta):
	value = character_component.current_health
