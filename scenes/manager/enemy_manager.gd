extends Node

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var timer = $Timer

const SPAWN_RADIUS = 350
var current_difficulty: int = 0

var base_spawn_time
var enemy_table = WeightedTable.new()
var enemy_speed = 60.0

func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	#enemy_table.add_item(wizard_enemy_scene, 10)
	timer.timeout.connect(spawn_enemy)
	arena_time_manager.arena_difficulty_inreased.connect(on_new_difficulty)
	base_spawn_time = timer.wait_time
	
func spawn_enemy():
	timer.start()
	
	var spawn_position = get_spawn_position()
	if spawn_position == null:
		return
	
	var enemy_scene : PackedScene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy) # parent is main
	enemy.global_position = spawn_position
	update_enemy_speed(enemy)

func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	
	var random_dir = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		var spawn_position = player.global_position + (random_dir  * SPAWN_RADIUS)
		var ray_params = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1) # got from collision mask terrain(1)
		var collision = get_tree().root.world_2d.direct_space_state.intersect_ray(ray_params)
		if collision.is_empty():
			return spawn_position
		elif i != 3:
			random_dir = random_dir.rotated(PI/2)

func update_enemy_speed(enemy):
	enemy.speed = min(enemy.speed + current_difficulty * enemy.speed_increment, enemy.max_speed)

func on_new_difficulty(difficulty: int):
	current_difficulty = difficulty
	timer.wait_time = max(0.05, base_spawn_time - (0.025) * difficulty)
	
	if difficulty == 12:
		enemy_table.add_item(wizard_enemy_scene, 20)
	
