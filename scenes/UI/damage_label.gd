extends Label

func _ready():
	$Timer.timeout.connect(on_timeout)
	
func on_timeout():
	queue_free()
