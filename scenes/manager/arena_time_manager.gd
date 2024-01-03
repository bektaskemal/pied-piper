extends Node
class_name ArenaTimeManager

signal arena_difficulty_inreased(difficulty: int)

@export var end_screen_scene: PackedScene

@onready var timer = $Timer as Timer

const DIFFICULTY_INTERVAL = 5
var arena_difficulty = 0

func _ready():
	timer.timeout.connect(on_victory)

func _process(delta):
	var next_remanining_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_remanining_time_target:
		arena_difficulty += 1
		arena_difficulty_inreased.emit(arena_difficulty)

func get_time_left():
	return timer.time_left

func on_victory():
	var victory_screen = end_screen_scene.instantiate()
	add_child(victory_screen)
