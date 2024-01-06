extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var dmg_label: PackedScene


func _ready():
	area_entered.connect(on_attacked)
	
func on_attacked(attacker: Area2D):
	if not attacker is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	var attacker_hitbox = attacker as HitboxComponent
	
	health_component.damage(attacker_hitbox.damage)
	
	var label = dmg_label.instantiate() as Label
	label.text = str(attacker_hitbox.damage)
	label.global_position = get_parent().global_position + Vector2(-8, -30)
	if attacker_hitbox.damage == attacker_hitbox.max_damage:
		label.add_theme_color_override("font_color", Color("E84537"))
	else:
		label.add_theme_color_override("font_color", Color("FF706D"))
		
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(label)
	
	
