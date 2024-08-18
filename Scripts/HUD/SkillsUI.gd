extends Control

@export var player : Player

@onready var upper_sprite : TextureRect = %UpperSkill
@onready var selected_sprite : TextureRect = %SelectedSkill
@onready var lower_sprite : TextureRect = %LowerSkill

var _sprites := {
	Ability.Type.MantisSlash : preload("res://Arte/Sprites/mantisSlash.png"),
	Ability.Type.CrabJet : preload("res://Arte/Sprites/crabJet.png"),
	Ability.Type.BearStomp : preload("res://Arte/Sprites/bearStomp.png"),
	Ability.Type.DragonBreath : preload("res://Arte/Sprites/dragonBreath.png")
}

func _ready() -> void:
	player.ability_changed.connect(_on_ability_changed)

func _on_ability_changed(ability: Ability.Type):
	var upper_index := (player.selected_ability + 1) % len(player.cc.available_abilities_to_scroll)
	var lower_index := (player.selected_ability - 1) % len(player.cc.available_abilities_to_scroll)
	var upper_ability := player.cc.available_abilities_to_scroll[upper_index]
	var lower_ability := player.cc.available_abilities_to_scroll[lower_index]
	var selected_ability := player.cc.available_abilities_to_scroll[player.selected_ability]
	
	upper_sprite.texture = _sprites[upper_ability]
	lower_sprite.texture = _sprites[lower_ability]
	selected_sprite.texture = _sprites[selected_ability]
