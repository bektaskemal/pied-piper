extends CanvasLayer

func _ready():
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart)
	%QuitButton.pressed.connect(on_quit)
	
func set_defeat():
	%TitleLabel.text = "DEFEAT"
	%DescriptionLabel.text = "You lost!"
	

func on_restart():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	queue_free()
	
func on_quit():
	get_tree().quit()
	
