extends Node

@export var axe_ability_scene: PackedScene

@onready var timer = $Timer as Timer

var min_damage = 7
var max_damage = 13
var base_wait_time 

func _ready():
	timer.timeout.connect(on_timeout)
	base_wait_time = timer.wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgraded)
	
func on_timeout():
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
		
	var axe = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe)
	axe.global_position = player.global_position
	
	var dmg = randi_range(min_damage, max_damage)
	axe.hitbox_component.damage = dmg

func on_ability_upgraded(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id != "axe_rate": # Not related to sword
		return
	var percent_reduction = min(0.9, current_upgrades["axe_rate"]["quantity"] * .1)
	timer.wait_time = base_wait_time * (1 - percent_reduction)
	timer.start() # reset
