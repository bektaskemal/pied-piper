extends CharacterBody2D

@onready var visuals = $Visuals
@onready var animation_player = $AnimationPlayer
@onready var velocity_component = $VelocityComponent

@export var speed: float = 70
@export var speed_increment: float = 2
@export var max_speed: float = 110

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity_component.max_speed = speed
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	if velocity != Vector2.ZERO:
		animation_player.speed_scale = speed/80
		animation_player.play("walk")
		var x_dir = sign(velocity.x)
		if x_dir != 0:
			visuals.scale.x = x_dir
	else:
		animation_player.play("RESET")


