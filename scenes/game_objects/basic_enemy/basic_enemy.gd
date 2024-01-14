extends CharacterBody2D

@onready var visuals = $Visuals
@onready var animation_player = $AnimationPlayer
@onready var velocity_component = $VelocityComponent

@export var speed: float = 60
@export var speed_increment: float = 2.0
@export var max_speed: float = 96

func _ready():
	$HurtboxComponent.hit.connect(on_hit)

func _process(delta):
	velocity_component.move(self, delta)
	
	if velocity != Vector2.ZERO:
		var x_dir = sign(velocity.x)
		if x_dir != 0:
			visuals.scale.x = x_dir

func set_speed(new_speed: float):
	speed = new_speed
	velocity_component.max_speed = speed
	animation_player.speed_scale = speed/80
	
func on_hit():
	$RandomStreamPlayer2D.play_random()
	
