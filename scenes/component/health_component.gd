extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health: float = 10
var current_health

func _ready():
	current_health = max_health
	if owner is Player: # TODO: Better handle?
		GameEvents.heal_vial_collected.connect(heal)

func damage(dmg: float):
	current_health = max(current_health - dmg, 0)
	Callable(check_death).call_deferred() # call it on next idle frame
	# error_msg: Can't change this state while flushing queries
	health_changed.emit()
	$HealthAnimationPlayer.play("damage")
	
func heal(hp: float):
	if current_health == max_health:
		return
	current_health = min(current_health + hp, max_health)
	health_changed.emit()
	$HealthAnimationPlayer.play("heal")

func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)

func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()
