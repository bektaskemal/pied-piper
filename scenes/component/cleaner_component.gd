extends Node

@onready var timer = $Timer

@export var clean_time: float = 25
@export var check_time_after_first: float = 10

const CLEAN_DISTANCE = 340

func _ready():
	timer.timeout.connect(on_timeout)
	timer.start(clean_time)
	
func on_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	if (player.global_position - (owner as Node2D).global_position).length() > CLEAN_DISTANCE:
		owner.queue_free()
	else:
		timer.start(check_time_after_first)
		
