extends CanvasLayer

signal endless_mode

func _ready():
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart)
	%EndlessButton.pressed.connect(on_endless)
	%QuitButton.pressed.connect(on_quit)
	if OS.has_feature("web"):
		%QuitButton.visible = false
		
	
func set_defeat():
	%TitleLabel.text = "DEFEAT"
	%DescriptionLabel.text = "You lost!"
	%EndlessButton.visible = false
	
func on_restart():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	queue_free()
	
func on_endless():
	get_tree().paused = false
	endless_mode.emit()
	queue_free()
	
func on_quit():
	get_tree().quit()
	
