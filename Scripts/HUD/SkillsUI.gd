extends Control

@export var player : Player

@onready var upper_sprite : TextureRect = %UpperSkill
@onready var selected_sprite : TextureRect = %SelectedSkill
@onready var lower_sprite : TextureRect = %LowerSkill

@onready var jump_ui := %JumpUI
@onready var glide_ui := %GlideUI

var _sprites := {
	Ability.Type.MantisSlash : preload("res://Arte/Sprites/mantisSlash.png"),
	Ability.Type.CrabJet : preload("res://Arte/Sprites/crabJet.png"),
	Ability.Type.BearStomp : preload("res://Arte/Sprites/bearStomp.png"),
	Ability.Type.DragonBreath : preload("res://Arte/Sprites/dragonBreath.png")
}

func _ready() -> void:
	player.ability_changed.connect(_on_ability_changed)
	player.cc.ability_unlocked.connect(_on_ability_unlocked)
	
	jump_ui.visible = false
	glide_ui.visible = false

func _on_ability_changed(ability: Ability.Type):
	var available_abilities_amount := len(player.cc.available_abilities_to_scroll)
	var upper_index := (player.selected_ability_index + 1) % available_abilities_amount
	var lower_index := (player.selected_ability_index - 1) % available_abilities_amount
	var upper_ability := player.cc.available_abilities_to_scroll[upper_index]
	var lower_ability := player.cc.available_abilities_to_scroll[lower_index]
	var selected_ability_index := player.cc.available_abilities_to_scroll[player.selected_ability_index]
	
	if available_abilities_amount > 1:
		upper_sprite.texture = _sprites[upper_ability]
		lower_sprite.texture = _sprites[lower_ability]
	selected_sprite.texture = _sprites[selected_ability_index]

func _on_ability_unlocked(ability: Ability.Type):
	match ability:
		Ability.Type.DuckGlide:
			%TutorialGlowGlide.show_glow()
			glide_ui.visible = true
		Ability.Type.FrogJump:
			%TutorialGlowJump.show_glow()
			jump_ui.visible = true
		_:
			%TutorialGlowBasic.show_glow()
