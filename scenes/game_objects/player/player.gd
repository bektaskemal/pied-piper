extends CharacterBody2D
class_name Player

@onready var collision_area = $CollisionArea2D as Area2D
@onready var dmg_timer = $DamageIntervalTimer as Timer
@onready var health_component = $HealthComponent as HealthComponent
@onready var health_bar = $HealthBar as ProgressBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var visuals = $Visuals as Node2D
@onready var shield: MeshInstance2D = $Visuals/Sprite2D/Shield
@onready var shield_audio_player = $ShieldAudioPlayer

const ACCELERATION = 20
const SPEED_INCREMENT = 5

var has_shield = false
var max_speed = 125
var number_of_colliding_bodies = 0

func _ready():
	collision_area.body_entered.connect(on_body_entered)
	collision_area.body_exited.connect(on_body_exited)
	dmg_timer.timeout.connect(check_deal_damage) 
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgraded)
	health_bar.value = health_component.get_health_percent()
	$ShieldTimer.timeout.connect(enable_shield)
	

func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * max_speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION))
	move_and_slide()
	
	if direction != Vector2.ZERO:
		animation_player.play("walk")
		var move_dir = sign(direction.x)
		if move_dir != 0:
			visuals.scale.x = move_dir
	else:
		animation_player.play("RESET")
		
	if has_shield:
		shield.visible = true
	else:
		shield.visible = false
	
	
func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement,y_movement)
	
func check_deal_damage():
	if number_of_colliding_bodies == 0:
		return
	if has_shield:
		has_shield = false
		shield_audio_player.play_shield_down()
		$ShieldTimer.start()
		return
	health_component.damage(min(number_of_colliding_bodies,4))
	$HurtAudioPlayer.play_random()
	dmg_timer.start()

func on_body_entered(body: Node2D):
	number_of_colliding_bodies += 1
	check_deal_damage()
	
func on_body_exited(body: Node2D):
	number_of_colliding_bodies -= 1
	
func on_health_changed(change):
	health_bar.value = health_component.get_health_percent()

func on_ability_upgraded(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if not upgrade is Ability and not upgrade.id in ["speed", "shield", "shield_rate"]:
		return
		
	if upgrade.id == "speed":
		max_speed += SPEED_INCREMENT
		return
		
	if upgrade.id == "shield":
		enable_shield()
		return
	if upgrade.id == "shield_rate":
		$ShieldTimer.wait_time -= 1
		return
	
	var ability = upgrade as Ability
	abilities.add_child(ability.ability_controller_scene.instantiate())

func enable_shield():
	has_shield = true
	shield_audio_player.play_shield_up()
