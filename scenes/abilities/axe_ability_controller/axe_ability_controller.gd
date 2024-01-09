extends Node

@export var axe_ability_scene: PackedScene

@onready var timer = $Timer as Timer

var base_min_damage = 8
var base_max_damage = 12
var min_damage
var max_damage 
var base_wait_time 

func _ready():
	timer.timeout.connect(spawn)
	base_wait_time = timer.wait_time
	min_damage = base_min_damage
	max_damage = base_max_damage
	GameEvents.ability_upgrade_added.connect(on_ability_upgraded)
	spawn()
	
func spawn():
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
	axe.hitbox_component.max_damage = max_damage

func on_ability_upgraded(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "axe_rate":
		var percent_reduction = min(0.9, current_upgrades["axe_rate"]["quantity"] * .1)
		timer.wait_time = base_wait_time * (1 - percent_reduction)
		timer.start() # reset
		spawn()
		return
	
	if upgrade.id == "axe_damage":
		var percent_increase = min(1.0, current_upgrades["axe_damage"]["quantity"] * .1)
		min_damage = ceil(base_min_damage * (1 + percent_increase))
		max_damage = ceil(base_max_damage * (1 + percent_increase))
