extends Node

@export_range(0,1) var drop_percent: float = 0.55
@export var vial_scene: PackedScene
@export var health_component: Node



func _ready():
	(health_component as HealthComponent).died.connect(on_died)
	
func on_died():
	if randf() > drop_percent:
		return
	if vial_scene == null:
		return
	if not owner is Node2D:
		return
	
	var spawn_position = (owner as Node2D).global_position
	spawn_position += Vector2.RIGHT.rotated(randf_range(0,TAU)) * 8
	var vial = vial_scene.instantiate() as Node2D
	vial.global_position = spawn_position
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(vial)
	
	 
	
