extends Decimal

func activate() -> void:
	if current_charges > 0:
		keypad.add(1)
		remove_charges(1)

func init_upgrade() -> void:
	restore_charges()
