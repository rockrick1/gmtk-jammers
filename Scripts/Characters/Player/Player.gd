class_name Player
extends CharacterBody3D

const LERP_VALUE : float = 0.25
const ANIMATION_BLEND : float = 7
const SCALE_ANIMATION_TIME := 1

signal ability_changed(ability: Ability.Type)
signal ability_released

@export var gravity : float = 50.0

@onready var character_component := $CharacterComponent
@onready var spring_arm_pivot := $SpringArmPivot
@onready var animator := %AnimationTree
@onready var movement_state_machine := $MovementStateMachine
@onready var consumption_area := $LookAtPivot/ConsumptionArea

@onready var abilities_scenes := {
	Ability.Type.MantisSlash : load("res://Scenes/Abilities/MantisSlash.tscn"),
	Ability.Type.CrabJet : preload("res://Scenes/Abilities/CrabJet.tscn"),
	Ability.Type.BearStomp : preload("res://Scenes/Abilities/MantisSlash.tscn"),
	Ability.Type.DragonBreath : preload("res://Scenes/Abilities/MantisSlash.tscn"),
}

var can_bite := true
var current_size := scale
var looking_at_cursor : bool:
	get:
		return not %LookAtCursorTimer.is_stopped()

var selected_ability_index := -1

var cc : CharacterComponent:
	get:
		return character_component
var snap_vector : Vector3 = Vector3.DOWN
var h_speed : float

func _ready():
	cc.died.connect(_on_died)
	cc.damaged.connect(_on_damaged)
	cc.ability_unlocked.connect(_on_ability_unlocked)
	movement_state_machine.initialize()

func _process(_delta):
	_look_at_cursor()
	
	if Input.is_action_pressed("left_click"):
		_bite()
	
	if Input.is_action_pressed("right_click"):
		%LookAtCursorTimer.start()
	
	if Input.is_action_just_pressed("right_click"):
		_try_use_ability()
	
	if Input.is_action_just_released("right_click"):
		%SkeletonIK3D.stop()
		ability_released.emit()
		
	if Input.is_action_just_pressed("wheel_up"):
		_scroll_ability(1)
		
	if Input.is_action_just_pressed("wheel_down"):
		_scroll_ability(-1)
		
	if Input.is_key_pressed(KEY_3):
		selected_ability_index = Ability.Type.BearStomp
		
	if Input.is_key_pressed(KEY_4):
		selected_ability_index = Ability.Type.DragonBreath

func update_rotation():
	$LookAtPivot.rotation.y = lerp_angle($LookAtPivot.rotation.y, atan2(velocity.x, velocity.z), LERP_VALUE)

func _look_at_cursor():
	if %LookAtCursorTimer.is_stopped():
		return
	
	var ray_origin
	var ray_end
	
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	ray_origin = %Camera3D.project_ray_origin(mouse_position)
	ray_end = ray_origin + %Camera3D.project_ray_normal(mouse_position) * 2000
	var query = PhysicsRayQueryParameters3D.new()
	query.from = ray_origin
	query.to = ray_end
	query.collide_with_bodies = true
	query.collision_mask = 128
	var intersection = space_state.intersect_ray(query)
	
	if not intersection.is_empty():
		var pos = intersection.position
		$LookAtPivot.look_at(pos)
		$LookAtPivot.rotation.y += PI

func _bite():
	if not %BiteTimer.is_stopped():
		return
	
	%LookAtCursorTimer.start()
	%BiteTimer.start()
	animator.set("parameters/bite/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	await get_tree().create_timer(%BiteTimer.wait_time / 2).timeout
	
	_try_consume()

func _try_consume():
	for body in consumption_area.get_overlapping_bodies():
		if body is not BaseAnimal:
			continue
		_consume(body)
		return

func _try_use_ability():
	if selected_ability_index == -1:
		return
	
	var ability := cc.available_abilities_to_scroll[selected_ability_index]
	if not cc.abilities.has(ability):
		return
	if not abilities_scenes.has(ability):
		return
	
	if ability == Ability.Type.MantisSlash:
		if not %MantisSlashTimer.is_stopped():
			return
		else:
			%MantisSlashTimer.start()
	if ability == Ability.Type.BearStomp:
		if not %BearStompTimer.is_stopped():
			return
		else:
			%BearStompTimer.start()
	
	%LookAtCursorTimer.start()
	var ability_instance : Ability = abilities_scenes[ability].instantiate()
	ability_instance.level = cc.abilities[ability]
	if ability == Ability.Type.DragonBreath or ability == Ability.Type.CrabJet:
		%SkeletonIK3D.start()
		ability_instance.player = self
		%ProjectilesParent.add_child(ability_instance)
	else:
		%AbilitiesParent.add_child(ability_instance)

func _consume(animal: BaseAnimal):
	animal.consume()
	_change_size(animal.size_value)
	cc.add_ability(animal.ability)
	pass

func _change_size(amount: float):
	current_size += Vector3(amount, amount, amount)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", current_size, SCALE_ANIMATION_TIME)

func _scroll_ability(scroll: int):
	if len(cc.available_abilities_to_scroll) == 0:
		return
	
	selected_ability_index = (selected_ability_index + scroll) % len(cc.available_abilities_to_scroll)
	ability_changed.emit(cc.available_abilities_to_scroll[selected_ability_index])

func _on_damaged(amount: int):
	pass

func _on_ability_unlocked(ability: Ability.Type):
	var index = cc.available_abilities_to_scroll.find(ability)
	if index == -1:
		return
	
	selected_ability_index = index
	ability_changed.emit(cc.available_abilities_to_scroll[selected_ability_index])

func _on_died():
	print("YOU DIED!!!")
