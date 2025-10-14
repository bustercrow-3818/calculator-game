extends Upgrade
class_name Decimal

@export var base_charges: int

var decimal: Button
var current_charges: int
var active: bool = false

func restore_charges(bonus_charges: int = 0) -> void:
	current_charges = base_charges + bonus_charges
	keypad.charges.text = str(current_charges)
	disable_enable_self()

func remove_charges(qty: int = 0) -> void:
	current_charges -= qty
	keypad.charges.text = str(current_charges)
	disable_enable_self()

func activate() -> void:
	pass
	
func deactivate() -> void:
	pass

func connect_signals() -> void:
	print(str("connecting signals for %s in parent %s") % [self.name, self.get_parent().name])
	SignalBus.difficulty_increase.connect(restore_charges)

func disable_enable_self() -> void:
	if current_charges == 0:
		decimal.disabled = true
	elif current_charges > 0:
		decimal.disabled = false

func remove() -> void:
	decimal.disabled = true
	keypad.charges.text = ""
	queue_free()
