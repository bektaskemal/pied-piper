extends Node2D
class_name AxeAbility

const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent

var base_rotation: Vector2

func _ready():
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var tween = create_tween() # Alternative to Animation
	tween.tween_method(tween_method, 0.0, 1.5, 2)
	tween.tween_callback(queue_free) # on done
	
func tween_method(rotations: float):
	var percent = rotations / 2 # 2 is max value defined above
	var current_radius = percent * MAX_RADIUS
	var current_dir = base_rotation.rotated(rotations * TAU)
	
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	
	global_position = player.global_position + (current_dir * current_radius)	

