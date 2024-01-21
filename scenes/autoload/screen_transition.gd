extends CanvasLayer

signal transition_halfway

func transition():
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished
	transition_halfway.emit()
	$AnimationPlayer.play_backwards("default")
