extends CanvasLayer

func _ready():
	%PlayButton.pressed.connect(on_play_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	if OS.has_feature("web"):
		%QuitButton.visible = false
	
func on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func on_quit_pressed():
	get_tree().quit()
	
