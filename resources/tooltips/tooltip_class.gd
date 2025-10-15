extends Resource
class_name TooltipData

@export_enum("Passive", "Decimal", "Other") var type: String
@export var cost: int
@export_multiline var description: String

func get_cost() -> int:
	return cost
	
func get_type() -> String:
	return type
	
func get_description() -> String:
	return description
