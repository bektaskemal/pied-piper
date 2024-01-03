extends CanvasLayer

@export var experience_manager: ExperienceManager
@onready var progress_bar = $MarginContainer/ProgressBar

func _ready():
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)
	
func on_experience_updated(current_exp: float, target_exp: float):
	if target_exp == 0:
		progress_bar.value = 1
	else:
		progress_bar.value = current_exp/target_exp
