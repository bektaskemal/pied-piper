extends CanvasLayer

@onready var panel_container = %PanelContainer

signal endless_mode

func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .0) #hacky, scale = 0 doesn't work properly
	tween.tween_property(panel_container, "scale", Vector2.ONE, .5)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
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
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	queue_free()
	
func on_endless():
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	endless_mode.emit()
	queue_free()
	
func on_quit():
	get_tree().quit()
	
