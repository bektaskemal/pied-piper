extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

signal hit

var dmg_label: PackedScene = preload("res://scenes/UI/floating_text.tscn")


func _ready():
	area_entered.connect(on_attacked)
	
func on_attacked(attacker: Area2D):
	if not attacker is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	var attacker_hitbox = attacker as HitboxComponent
	
	health_component.damage(attacker_hitbox.damage)
	var is_crit = (attacker_hitbox.damage == attacker_hitbox.max_damage)
	var max_scale = 1.5 if is_crit else 1.0
	var label = dmg_label.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(label)
	label.global_position = global_position + Vector2.UP * 16
	label.start(str(attacker_hitbox.damage), max_scale)
	hit.emit()
		
	
	
	
