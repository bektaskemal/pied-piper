extends Sprite2D

@onready var parent = $".."

var pressing = false

@export var maxLength = 50
@export var action_left := "move_left"
@export var action_right := "move_right"
@export var action_up := "move_up"
@export var action_down := "move_down"
var deadzone = 15

func _ready():
	deadzone = parent.deadzone
	maxLength *= parent.scale.x
	GameEvents.ability_upgrade_added.connect(on_ability_upgraded)
	
	
func _process(delta):
	if pressing:
		if get_global_mouse_position().distance_to(parent.global_position) <= maxLength:
			global_position = get_global_mouse_position()
		else:
			var angle = parent.global_position.angle_to_point(get_global_mouse_position())
			global_position.x = parent.global_position.x + cos(angle)*maxLength
			global_position.y = parent.global_position.y + sin(angle)*maxLength
		calculateVector()
	else:
		global_position = lerp(global_position, parent.global_position, delta*50)
		parent.posVector = Vector2(0,0)
		reset_actions()
		
func calculateVector():
	var x = (global_position.x - parent.global_position.x)
	if abs(x) >= deadzone:
		parent.posVector.x = x/maxLength
		if sign(x) == 1:
			apply_action(action_right, parent.posVector.x)
		else:
			apply_action(action_left, abs(parent.posVector.x))
	var y = (global_position.y - parent.global_position.y)
	if abs(y) >= deadzone:
		parent.posVector.y = y/maxLength
		if sign(y) == 1:
			apply_action(action_down, parent.posVector.y)
		else:
			apply_action(action_up, abs(parent.posVector.y))
		
func apply_action(action:String, value:float):
	Input.action_press(action, value)
	
func reset_actions():
	Input.action_press(action_down, 0)
	Input.action_press(action_up, 0)
	Input.action_press(action_left, 0)
	Input.action_press(action_right, 0)
	

func _on_button_button_down():
	pressing = true

func _on_button_button_up():
	pressing = false

func on_ability_upgraded(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	pressing = false
