extends Node

@export var max_speed: float = 70.0
@export var acceleration: float = 10.0

const STOP_DISTANCE = 5
var velocity = Vector2.ZERO

func move(character: CharacterBody2D, delta: float):
	accelerate_to_player(delta)
	character.velocity = velocity
	character.move_and_slide()
	velocity = character.velocity

func accelerate_to_player(delta: float):
	var owner_node = owner as Node2D
	if owner_node == null:
		return
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	if owner_node.global_position.distance_to(player.global_position) < STOP_DISTANCE:
		accelerate_in_dir(Vector2.ZERO, delta)
	else:
		# TODO: Add lookahead using player.velocity to increase difficulty
		var direction = owner_node.global_position.direction_to(player.global_position)
		accelerate_in_dir(direction, delta)
	
func accelerate_in_dir(direction: Vector2, delta: float):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * delta))


