extends Node

signal exp_vial_collected(value: float)
signal heal_vial_collected(value: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)

func emit_exp_vial_collected(value: float):
	exp_vial_collected.emit(value)
	
func emit_heal_vial_collected(value: float):
	heal_vial_collected.emit(value)
	
func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)
