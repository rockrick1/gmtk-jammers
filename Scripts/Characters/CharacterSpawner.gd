class_name CharacterSpawner
extends MeshInstance3D

@export var character_scene : PackedScene
@export var min_spawn_count : int
@export var max_spawn_count : int
@export var interval : float
@export var max_active_entities : int

@export var character_size : float = 1.0

@export var enabled_override := true

var active_entities := 0
var enabled := false:
	set(value):
		_enabled = value and enabled_override
		if (_enabled):
			_on_group_spawn_timer_timeout()
			$GroupSpawnTimer.start()
		else:
			$GroupSpawnTimer.stop()

var _enabled := false

func _ready():
	$GroupSpawnTimer.wait_time = interval
	_on_group_spawn_timer_timeout()

func _on_group_spawn_timer_timeout():
	for i in range(randi_range(min_spawn_count, max_spawn_count)):
		if active_entities >= max_active_entities:
			return
		if not _enabled:
			return
		
		_setup_and_spawn_enemy(character_scene)

func _setup_and_spawn_enemy(character_scene: PackedScene):
	var character_instance = character_scene.instantiate()
	add_child(character_instance)
	character_instance.position = _get_spawn_point()
	character_instance.scale = Vector3.ONE * character_size
	character_instance.tree_exited.connect(_handle_entity_freed)
	active_entities += 1

func _handle_entity_freed():
	active_entities -= 1

func _get_spawn_point() -> Vector3:
	var aabb : AABB = get_aabb()
	var random_x = randf()
	var random_y = randf()
	var random_z = randf()
	var aabb_size = aabb.size
	var random_point = Vector3(
		aabb.position.x + random_x * aabb_size.x,
		aabb.position.y + random_y * aabb_size.y,
		aabb.position.z + random_z * aabb_size.z
	)
	return random_point
