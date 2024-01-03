extends Node2D

const HEAL_AMOUNT = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.area_entered.connect(pickup)

func pickup(pickup_area: Area2D):
	GameEvents.emit_heal_vial_collected(HEAL_AMOUNT)
	queue_free() 
