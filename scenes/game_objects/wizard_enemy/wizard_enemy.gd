extends CharacterBody2D

@onready var visuals = $Visuals
@onready var animation_player = $AnimationPlayer
@onready var velocity_component = $VelocityComponent

@export var base_speed: float = 70
@export var speed_increment: float = 1.5
@export var max_speed: float = 110
@export var endless_mode_max_speed: float = 120

func _ready():
	$HurtboxComponent.hit.connect(on_hit)
	GameEvents.endless_mode.connect(on_endless_mode)

func _process(delta):
	velocity_component.move(self, delta)
	
	if velocity != Vector2.ZERO:
		var x_dir = sign(velocity.x)
		if x_dir != 0:
			visuals.scale.x = x_dir

func set_speed_level(level: int):
	velocity_component.max_speed = min(base_speed + level * speed_increment, max_speed)
	animation_player.speed_scale = velocity_component.max_speed/80

func on_endless_mode():
	max_speed = endless_mode_max_speed

func on_hit():
	$RandomStreamPlayer2D.play_random()
