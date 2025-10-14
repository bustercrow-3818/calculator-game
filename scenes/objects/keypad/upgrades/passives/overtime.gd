extends PassiveUpgrade

@export var bonus_time: float

func _ready() -> void:
	description = description.format([bonus_time])

func upgrade_stats() -> void:
	clock.bonus_time += bonus_time

func downgrade_stats() -> void:
	clock.bonus_time -= bonus_time

func init_upgrade() -> void:
	upgrade_stats()
