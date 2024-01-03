extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label = $VBoxContainer/NameLabel as Label
@onready var desc_label = $VBoxContainer/DescriptionLabel as Label

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
	var style:StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color =  Color.AZURE
	style.bg_color.a = 0.5
	add_theme_stylebox_override ("panel", style)
	
func on_mouse_exited():
	remove_theme_stylebox_override("panel")
