extends Node

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene

@onready var timer = $Timer


const SPAWN_RADIUS = 350
const MAX_SPAWN_RATE = 20.0
const WIZARD_ENEMY_WEIGHT = 2
var current_difficulty: int = 0

var spawn_rate_increment = 0.2
var base_spawn_rate: float
var spawn_rate: float
var enemy_table = WeightedTable.new()


func _ready():
	enemy_table.add_item(basic_enemy_scene)
	timer.timeout.connect(spawn_enemy)
	GameEvents.difficulty_changed.connect(on_new_difficulty)
	base_spawn_rate = 1/timer.wait_time
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
	enemy.set_speed_level(current_difficulty)

func update_spawn_rate(difficulty: float):
	spawn_rate = min(base_spawn_rate + difficulty * spawn_rate_increment, MAX_SPAWN_RATE)

func on_new_difficulty(difficulty: int):
	if difficulty == 16:
		enemy_table.add_item(wizard_enemy_scene, WIZARD_ENEMY_WEIGHT)
	elif difficulty == 24:
		var new_increment = 0.33
		base_spawn_rate -= current_difficulty*(new_increment - spawn_rate_increment)
		spawn_rate_increment = new_increment

	current_difficulty = difficulty
	update_spawn_rate(difficulty)
	timer.wait_time = 1 / spawn_rate
	
	
