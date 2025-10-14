extends Decimal

func activate() -> void:
	target.set_new_target()
	remove_charges(1)

func init_upgrade() -> void:
	restore_charges()
