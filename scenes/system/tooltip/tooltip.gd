extends Control
class_name Tooltip

@export var data: Resource

@onready var type: Label = $VBoxContainer/HBoxContainer/type
@onready var cost: Label = $VBoxContainer/HBoxContainer/cost
@onready var description: Label = $VBoxContainer/description

var tracking: bool = false

func _process(delta: float) -> void:
	size = get_minimum_size()

func show_tooltip(button: Button) -> void:
	type.text = data.type
	cost.text = data.cost
	description.text = data.description
	#tooltip_label.text = upgrade_tooltips[button.text]
	#tooltip_block.show()
	#tooltip_tracking = true
	pass
	
func hide_tooltip() -> void:
	#tooltip_tracking = false
	#tooltip_block.hide()
	pass
