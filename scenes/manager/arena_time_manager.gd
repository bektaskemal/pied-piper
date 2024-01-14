extends Node
class_name ArenaTimeManager

signal arena_difficulty_inreased(difficulty: int)

@export var end_screen_scene: PackedScene

@onready var timer = $Timer as Timer

const DIFFICULTY_INTERVAL = 5
var next_time_target = DIFFICULTY_INTERVAL
var arena_difficulty = 0
var endless_mode: bool = false

func _ready():
	timer.timeout.connect(on_victory)
	#if OS.has_feature("web"):
		#timer.start(timer.wait_time*5/6)

func _process(delta):
	if (timer.wait_time - timer.time_left) >= next_time_target:
		next_time_target += DIFFICULTY_INTERVAL
		arena_difficulty += 1
		arena_difficulty_inreased.emit(arena_difficulty)

func on_endless_mode():
	endless_mode = true
	timer.start(600)
	next_time_target = DIFFICULTY_INTERVAL

func get_time_to_print():
	return (timer.wait_time - timer.time_left)  if endless_mode else timer.time_left

func on_victory():
	var victory_screen = end_screen_scene.instantiate()
	add_child(victory_screen)
	victory_screen.endless_mode.connect(on_endless_mode)
	victory_screen.play_jingle(victory_screen.RESULT.VICTORY)
