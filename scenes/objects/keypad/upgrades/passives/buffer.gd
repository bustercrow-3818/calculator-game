extends PassiveUpgrade

func upgrade_stats() -> void:
	keypad.max_difficulty -= 1
	
func activate_effect() -> void:
	pass

func downgrade_stats() -> void:
	keypad.max_difficulty += 1

func init_upgrade() -> void:
	upgrade_stats()
