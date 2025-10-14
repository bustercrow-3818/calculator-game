extends Node2D
class_name UpgradeManager

@export var keypad: Control
@export var target: Node2D
@export var clock: Control
var current_decimal: Decimal
var decimal: Button

func _ready() -> void:
	SignalBus.pick_upgrade.connect(gain_upgrade)
	SignalBus.game_over.connect(game_over_cleanup)
	SignalBus.checkpoint_exit_signal.connect(decimal_restore_charges)
	decimal = get_tree().get_first_node_in_group("decimal")
	decimal.pressed.connect(activate_decimal)

func activate_decimal() -> void:
	if current_decimal == null:
		return
	current_decimal.activate()

func gain_upgrade(upgrade: Upgrade, _unhandled_input = null) -> void:
	add_child(upgrade)
	if upgrade is PassiveUpgrade:
		gain_passive(upgrade)
	elif upgrade is Decimal:
		gain_decimal(upgrade)
	
func gain_decimal(new_decimal: Decimal, _unhandled_input = null) -> void:
	if current_decimal != null:
		current_decimal.queue_free()
	
	current_decimal = new_decimal
	set_decimal_data()
	current_decimal.init_upgrade()
	current_decimal.connect_signals()

func gain_passive(passive: PassiveUpgrade, _unhandled_input = null) -> void:
	set_passive_data(passive)
	

func set_decimal_data() -> void:
	if current_decimal == null:
		decimal.disabled = true
		return
	
	current_decimal.keypad = keypad
	current_decimal.target = target
	current_decimal.clock = clock
	current_decimal.decimal = decimal
	current_decimal.restore_charges()
	current_decimal.init_upgrade()
	
func set_passive_data(passive: PassiveUpgrade) -> void:
	passive.keypad = keypad
	passive.target = target
	passive.clock = clock
	passive.init_upgrade()

func get_current_passives() -> Array[PassiveUpgrade]:
	var current_passives: Array[PassiveUpgrade]
	
	for i in get_children():
		if i is PassiveUpgrade:
			current_passives.append(i)
			
	return current_passives

func get_current_decimal() -> Decimal:
	return current_decimal

func remove_decimal() -> void:
	current_decimal.queue_free()
	decimal.disabled = true
	
func remove_passives() -> void:
	for i in get_current_passives():
		i.downgrade_stats()
		i.queue_free()

func game_over_cleanup() -> void:
	current_decimal.remove()
	remove_passives()

func decimal_restore_charges() -> void:
	if current_decimal != null:
		current_decimal.restore_charges()
