extends Node2D

const EXP_INCREMENT = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.area_entered.connect(pickup)

func pickup(pickup_area: Area2D):
	GameEvents.emit_exp_vial_collected(EXP_INCREMENT)
	queue_free() 
