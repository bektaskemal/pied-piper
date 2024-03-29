extends CanvasLayer
class_name UpgradeScreen

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_screen: PackedScene
@onready var card_container: HBoxContainer = %UpgradesContainer

func _ready():
	get_tree().paused = true

func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	for upgrade in upgrades:
		var card_instance = upgrade_card_screen.instantiate() as AbilityUpgradeCard
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
	set_focus()
	
func set_focus():
	card_container.grab_focus()
	card_container.focus_neighbor_bottom = card_container.get_child(0).get_path()
	card_container.focus_neighbor_right = card_container.get_child(0).get_path()
	
func on_upgrade_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	queue_free()
		
	
