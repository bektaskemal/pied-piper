extends Node

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var timer = $Timer


const SPAWN_RADIUS = 350
const MAX_SPAWN_RATE = 25.0
var current_difficulty: int = 0

var spawn_rate_increment = 0.15
var spawn_rate: float
var enemy_table = WeightedTable.new()


func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	timer.timeout.connect(spawn_enemy)
	arena_time_manager.arena_difficulty_inreased.connect(on_new_difficulty)
	spawn_rate = 1/timer.wait_time
	
func spawn_enemy():
	timer.start()
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	
	var spawn_position = get_spawn_position()
	if spawn_position == null:
		return
	
	var enemy_scene : PackedScene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	
	entities_layer.add_child(enemy) # parent is main
	enemy.global_position = spawn_position
	update_enemy_speed(enemy)

func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	
	var player_dir: Vector2 = player.velocity.normalized()
	var random_dir = player_dir.rotated(randf_range(-3*PI/5, 3*PI/5)) if player.velocity.length() > 10\
	 else Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		var spawn_position = player.global_position + (random_dir  * SPAWN_RADIUS)
		var raycast_position = spawn_position + (random_dir  * 5) # TODO: Should be radius of collision shape
		var ray_params = PhysicsRayQueryParameters2D.create(player.global_position, raycast_position, 1) # got from collision mask terrain(1)
		var collision = get_tree().root.world_2d.direct_space_state.intersect_ray(ray_params)
		if collision.is_empty():
			return spawn_position
		elif i != 3:
			random_dir = random_dir.rotated(PI/2)

func update_enemy_speed(enemy):
	enemy.set_speed(min(enemy.speed + current_difficulty * enemy.speed_increment, enemy.max_speed\
	if current_difficulty < 48 else 1.1 * enemy.max_speed)) #Endless mode TODO: Handle better

func update_spawn_rate(difficulty: float):
	spawn_rate_increment = 0.15 + floor(difficulty / 12) * 0.1
	spawn_rate = min(spawn_rate + spawn_rate_increment, 20)

func on_new_difficulty(difficulty: int):
	if difficulty == 16:
		enemy_table.add_item(wizard_enemy_scene, 20)

	current_difficulty = difficulty
	update_spawn_rate(difficulty)
	timer.wait_time = 1 / spawn_rate
	
	
