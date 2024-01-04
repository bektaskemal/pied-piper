extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}

func _ready():
	experience_manager.level_up.connect(on_level_up)
	
func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
		
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool = upgrade_pool.filter(func (pool_upgrade): return upgrade.id != pool_upgrade.id )
	
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)

func pick_upgrades():
	var filtered_upgrades = upgrade_pool.duplicate()
	filtered_upgrades = filtered_upgrades.filter(func(e) : return not filtered_upgrades.any(func(other) : return e != other and e.parent_id == other.id))
	
	var upgrade_options: Array[AbilityUpgrade] = []
	for i in 2:
		if filtered_upgrades.is_empty():
			break
		var chosen_option = filtered_upgrades.pick_random() as AbilityUpgrade
		upgrade_options.append(chosen_option)
		filtered_upgrades = filtered_upgrades.filter(func (upgrade: AbilityUpgrade): return upgrade.id != chosen_option.id)
		
	return upgrade_options
		

func on_level_up(level: int):	
	var upgrade_screen_instance = upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen_instance)
	var upgrade_options = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(upgrade_options as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
	
func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
		