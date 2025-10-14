extends Upgrade
class_name PassiveUpgrade

@export var purchase_cost: float ## Cost to select in seconds

func upgrade_stats() -> void:
	pass
	
func activate_effect() -> void:
	pass

func downgrade_stats() -> void:
	pass
