extends PassiveUpgrade

@onready var timer = $Timer
@export var base_bonus: float = 0
@export var timeout: float

var current_bonus: float = 0

func _ready() -> void:
	description = description.format([base_bonus, timeout])

func activate_effect() -> void:
	if current_bonus == 0:
		current_bonus += base_bonus
	else:
		current_bonus *= current_bonus
	timer.wait_time = timeout
	timer.start()

func reset() -> void:
	current_bonus = base_bonus

func score_up(_unhandled_bool: bool = false) -> void:
	target.set_score(clamp(snappedf(current_bonus, 0.01), 0, 1000))
	activate_effect()

func connect_signals() -> void:
	SignalBus.next_level.connect(score_up)
	timer.timeout.connect(reset)

func init_upgrade() -> void:
	connect_signals()
	current_bonus = base_bonus
