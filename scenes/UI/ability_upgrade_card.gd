extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label = $VBoxContainer/MarginContainer/NameLabel as Label
@onready var desc_label = $VBoxContainer/DescriptionLabel as Label

const PANEL_HOVER_TEXTURE = preload("res://resources/theme/panel_hover_texture.tres")

var mouse_inside = false

func _ready():
	gui_input.connect(on_selected)
	mouse_entered.connect(on_mouse_entered)
	focus_entered.connect(on_focus_entered)
	mouse_exited.connect(on_mouse_exited)
	focus_exited.connect(on_focus_exited)

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	desc_label.text = upgrade.description

func on_selected(event: InputEvent):
	if event.is_action_pressed("left_click") or (has_focus() && event.is_action_pressed("ui_accept")):
		selected.emit()
		
func on_mouse_entered():
	mouse_inside = true
	add_theme_stylebox_override ("panel", PANEL_HOVER_TEXTURE)
	
func on_focus_entered():
	add_theme_stylebox_override ("panel", PANEL_HOVER_TEXTURE)
	
func on_mouse_exited():
	if not has_focus():
		remove_theme_stylebox_override("panel")
	mouse_inside = false
		
func on_focus_exited():
	if not mouse_inside:
		remove_theme_stylebox_override("panel")
