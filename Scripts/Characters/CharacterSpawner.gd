extends MeshInstance3D

const MIN_ENEMY_SPAWN_COUNT := 2
const MAX_ENEMY_SPAWN_COUNT := 5
const INTRA_GROUP_SPAWN_INTERVAL := .3

@export var character_scene : PackedScene

func _on_group_spawn_timer_timeout():
	for i in range(randi_range(MIN_ENEMY_SPAWN_COUNT, MAX_ENEMY_SPAWN_COUNT)):
		_setup_and_spawn_enemy(character_scene)

func _setup_and_spawn_enemy(character_scene: PackedScene):
	var character_instance = character_scene.instantiate()
	add_child(character_instance)
	character_instance.position = _get_spawn_point()
	await get_tree().create_timer(INTRA_GROUP_SPAWN_INTERVAL).timeout

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
	return random_point + position
