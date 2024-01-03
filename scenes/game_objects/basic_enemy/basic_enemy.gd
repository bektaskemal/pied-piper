extends CharacterBody2D

@onready var visuals = $Visuals
@onready var animation_player = $AnimationPlayer

var max_speed = 70.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = get_direction_to_player()
	velocity = direction * max_speed
	move_and_slide()
	
	if direction != Vector2.ZERO:
		animation_player.speed_scale = max_speed/80
		animation_player.play("walk")
		var x_dir = sign(direction.x)
		if x_dir != 0:
			visuals.scale.x = x_dir
		#var y_dir = sign(direction.y)
		#if y_dir != 0:
			#visuals.scale.y = y_dir 
	else:
		animation_player.play("RESET")

func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO
