extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite = $Sprite2D

const EXP_INCREMENT = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.area_entered.connect(pickup)

func collect():
	GameEvents.emit_exp_vial_collected(EXP_INCREMENT)
	queue_free() 

func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var target_rotation = (player.global_position - start_position).angle() + PI/2
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-3 * get_process_delta_time()))

func disable_collision():
	collision_shape_2d.disabled = true
	
func pickup(pickup_area: Area2D):
	Callable(disable_collision).call_deferred() # to not try to pickup again
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, .08).set_delay(0.42)
	tween.chain()
	tween.tween_callback(collect)
	
	$RandomStreamPlayer2D.play_random()
