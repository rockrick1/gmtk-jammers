extends Label

@onready var cc = $"../CharacterComponent"
@onready var player = $".."
@onready var bite_level = $"."
@onready var mantis_level = $"../MantisLevel"



func _process(delta):
	bite_level.text = "Lv " + str(int(player.total_hunts/4) + 1)
	if cc.abilities.has(Ability.Type.MantisSlash):
		mantis_level.text = "Lv " + str(cc.abilities[Ability.Type.MantisSlash])
	else:
		mantis_level.text = " "
	
	
	
