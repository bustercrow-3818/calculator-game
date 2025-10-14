extends Menu
class_name Checkpoint

signal pickup_upgrade(upgrade: Upgrade)

@export var option_buttons: Array[Button]
@export var preview_next: HBoxContainer
@export var splash: Label
@export var upgrade_pool: Array[PackedScene]

@onready var tooltip_block = $VBoxContainer
@onready var tooltip_label = $VBoxContainer/tooltip
@onready var tooltip: Dictionary = {"block": $VBoxContainer,
"type": $VBoxContainer/HBoxContainer/type,
"cost": $VBoxContainer/HBoxContainer/cost,
"description": $VBoxContainer/tooltip}
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var test_var: PackedScene
@onready var next_level: Button = $Button

var button_signals: Dictionary
var current_options: Array[Upgrade]
var upgrade_tooltips: Dictionary
var upgrade_quarantine: Array[PackedScene]
var tooltip_tracking: bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if tooltip_tracking == true:
		tooltip_block.global_position.x = get_global_mouse_position().x - tooltip_label.size.x
		tooltip_block.global_position.y = get_global_mouse_position().y
		tooltip_block.size = tooltip_block.get_minimum_size()

func set_current_options() -> void:
	var new_upgrade
	for i in range(option_buttons.size()):
		new_upgrade = get_random_upgrade()
		if new_upgrade is Upgrade:
			current_options.append(new_upgrade)
			upgrade_tooltips[new_upgrade.name.capitalize()] = new_upgrade.description
	
	update_buttons()

func update_buttons() -> void:
	for i in option_buttons:
		var current_upgrade: Upgrade = current_options[i.get_index()]
		i.text = current_upgrade.plain_text_name
		i.pressed.connect(SignalBus.upgrade.bind(current_upgrade, i))

func get_random_upgrade() -> Upgrade:
	var selection = upgrade_pool.pick_random()
	upgrade_quarantine.append(selection)
	upgrade_pool.erase(selection)
	selection = selection.instantiate()
	return selection

func connect_signals() -> void:
	next_level.pressed.connect(SignalBus.relay_signal.bind("checkpoint_exit_signal"))
	SignalBus.debug.connect(debug)
	SignalBus.pick_upgrade.connect(pick_option)
	
	for i in option_buttons:
		i.mouse_entered.connect(show_tooltip.bind(i))
		i.mouse_exited.connect(hide_tooltip)

func clear_options() -> void:
	for i in current_options:
		i.queue_free()
	
	current_options.clear()
	
	for i in upgrade_quarantine:
		upgrade_pool.append(i)
	
	upgrade_quarantine.clear()
	
	for i in option_buttons:
		i.disconnect("pressed", SignalBus.upgrade)
		i.disabled = false

func get_current_upgrades() -> Array[Upgrade]:
	return current_options

func debug() -> void:
	for i in current_options:
		print(str(i))
		
	for i in upgrade_quarantine:
		print(str(i))

func pick_option(upgrade: Upgrade, _button: Button) -> void:
	current_options.erase(upgrade)
	for i in option_buttons:
		i.disabled = true

func breath_pulse(start: bool) -> void:
	if start == true:
		animation.play("pulse")
	else:
		animation.stop()

func show_tooltip(button: Button) -> void:
	tooltip_label.text = upgrade_tooltips[button.text]
	tooltip_block.show()
	tooltip_tracking = true
	pass
	
func hide_tooltip() -> void:
	tooltip_tracking = false
	tooltip_block.hide()
	pass
