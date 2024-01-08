extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label = $VBoxContainer/MarginContainer/NameLabel as Label
@onready var desc_label = $VBoxContainer/DescriptionLabel as Label

const PANEL_HOVER_TEXTURE = preload("res://resources/theme/panel_hover_texture.tres")

func _ready():
	gui_input.connect(on_selected)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	desc_label.text = upgrade.description

func on_selected(event: InputEvent):
	if event.is_action_pressed("left_click"):
		selected.emit()
		
func on_mouse_entered():
	var style = PANEL_HOVER_TEXTURE
	add_theme_stylebox_override ("panel", style)
	
	
func on_mouse_exited():
	remove_theme_stylebox_override("panel")
