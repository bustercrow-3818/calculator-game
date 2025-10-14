extends Node2D
class_name Target

@export var goal: Label
@export var title: Label
@export var score_display: Label
@export var difficulty: int ## Sets how many targets must be correct before increasing number of buttons disabled. Higher number = easier difficulty
@export var score_scaling: float

var total_score: float = 0
var targets_correct: int = 0
var level: int = 1
var hp: int
var og_color: Color = self.modulate
var og_position: Vector2

func _ready() -> void:
	og_position = position
	set_goal()
	
	# Signal from keypad to check if current value is correct
	SignalBus.score.connect(goal_update)
	
func _physics_process(_delta: float) -> void:
	if hp == 0:
		set_goal()

func game_start() -> void:
	level = 1
	total_score = 0
	targets_correct = 0
	update_display()
	set_goal(true)

func set_new_target(random: bool = true, fixed: int = 0) -> void:
	if random == true:
		hp = randi_range(11, 29 + (level * 10))
	else:
		hp = fixed
	update_display()

func set_goal(new_game: bool = false) -> void:
	set_new_target()
	SignalBus.next_level.emit(new_game)

func goal_update(qty: int) -> void:
	if qty == hp:
		targets_correct += 1
		set_score(level * score_scaling)
		set_goal()
	else:
		pass
	check_correct()

func get_correct_targets() -> int:
	return targets_correct

func set_correct_targets(qty: int) -> void:
	targets_correct = qty

func set_score(qty: float) -> void:
	total_score += snappedf(qty, 0.01)
	update_display()

func update_display() -> void:
	score_display.text = "Score: " + str(total_score)
	title.text = "Level " + str(level)
	goal.text = str(hp)
	SignalBus.system_score_update.emit(total_score)

func difficulty_increase() -> void:
	level += 1
	targets_correct = 0
	update_display()

func check_correct() -> void:
	if targets_correct == difficulty:
		SignalBus.checkpoint_signal.emit()
