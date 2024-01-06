extends Node

@export var health_component: HealthComponent
@export var sprite: Sprite2D
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween

const heal_color: Vector3 = Vector3(0.2, 1, 0.2)
const dmg_color: Vector3 = Vector3(1, 0.2, 0.2)

func _ready():
	sprite.material = hit_flash_material
	health_component.health_changed.connect(on_health_changed)
	
func on_health_changed(change):
	sprite.material = hit_flash_material # TODO: Shouldn't be needed?
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	if change >= 0:
		(sprite.material as ShaderMaterial).set_shader_parameter("color", heal_color)
	else:
		(sprite.material as ShaderMaterial).set_shader_parameter("color", dmg_color)
		
	
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 0.7)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", .0, .5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
