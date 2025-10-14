extends Decimal

var current_buttons: Array[Button]

func activate() -> void:
	if current_charges > 0:
		for i in keypad.get_disabled_numbers():
			current_buttons.append(i)
		for i in keypad.get_disabled_operators():
			current_buttons.append(i)
		active = true
		remove_charges(1)
		
		for i in current_buttons:
			i.modulate = Color(1, 1, 0, 1)
			if i.pressed.is_connected(deactivate) == false:
				i.connect("pressed", deactivate)
			i.disabled = false

func deactivate(_unhandled_input = 0) -> void:
	if active == false:
		return
	else:
		for i in current_buttons:
			i.modulate = Color(1, 1, 1, 1)
			if i.pressed.is_connected(deactivate):
				i.disconnect("pressed", deactivate)
			i.disabled = true
	
	current_buttons.clear()
	active = false
	disable_enable_self()

func init_upgrade() -> void:
	restore_charges()
