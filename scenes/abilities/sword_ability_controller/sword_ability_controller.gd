extends Node

@export var sword_ability: PackedScene

@onready var timer = $Timer as Timer

var min_damage = 5
var max_damage = 10
var base_wait_time 

const MAX_RANGE = 100 # export if needs configuration 


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(on_timer_timeout)
	base_wait_time = timer.wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgraded)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_timer_timeout():		
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2) 
	)
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(first: Node2D, second: Node2D): 
			return first.global_position.distance_squared_to(player.global_position) < second.global_position.distance_squared_to(player.global_position)
	)
	var closest_enemy = enemies[0] as Node2D
	
	var sword = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword)
	var dmg = randi_range(min_damage, max_damage)
	sword.hitbox_component.damage = dmg
	sword.hitbox_component.max_damage = max_damage
	sword.global_position = closest_enemy.global_position
	sword.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU)) * 4
	
	var enemy_direction = closest_enemy.global_position - sword.global_position
	sword.rotation = enemy_direction.angle()
	
func on_ability_upgraded(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id != "sword_rate": # Not related to sword
		return
	var percent_reduction = min(0.9, current_upgrades["sword_rate"]["quantity"] * .1)
	timer.wait_time = base_wait_time * (1 - percent_reduction)
	timer.start() # reset
	
	
