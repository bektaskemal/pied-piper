extends Node
class_name ExperienceManager

signal experience_updated(currrent_exp: float, target_exp: float)
signal level_up(new_level: int)

const TARGET_EXP_GROWTH = 5

var current_experince = 0
var current_level = 1
var target_experience = 3

func _ready():
	GameEvents.exp_vial_collected.connect(increment_experience)

func increment_experience(increment: float):
	current_experince = min(current_experince + increment, target_experience)
	experience_updated.emit(current_experince,target_experience)
	if current_experince == target_experience:
		current_level += 1
		target_experience += TARGET_EXP_GROWTH
		current_experince = 0
		experience_updated.emit(current_experince,target_experience)
		level_up.emit(current_level)
		

