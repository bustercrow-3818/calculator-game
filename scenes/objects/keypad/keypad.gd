extends Control
class_name Keypad ## Base class for keypads. All base calculator functionality and some helper functions are here. Add extra functionality as needed

@export var charges: Label
@export var disp: Label
@export var buttons: Array[Button] ## Includes number buttons eligible to be disabled for a round
@export var ops: Array[Button] ## Included operator buttons eligible to be disabled for a round
#@export var difficulty_scaling: int ## The number of buttons to cumulatively disable whenever difficulty increases

enum operators{ADDITION, SUBTRACTION, MULTIPLICATION, DIVISION, IDLE}

var new_value: bool = true
var current_operation
var current_val = 0
var val_a = 0
var current_difficulty: int = 1
@export var max_difficulty: int = 4

func _ready() -> void:
	current_operation = operators.IDLE
	
	# Signal from target that a new target is ready
	SignalBus.next_level.connect(clear)

	#region Signals from child buttons to tie them to their appropriate functions
	for i in get_tree().get_nodes_in_group("numbers"):
		i.connect("pressed", type.bind(i.name.to_int()))
	
	for i in get_tree().get_nodes_in_group("operators"):
		i.connect("pressed", operator.bind(i))
		
	get_tree().get_first_node_in_group("enter").connect("pressed", evaluate.bind(false))
	#endregion
	
	game_start()

func type(digit: int) -> void:  ## Entering digit into display
	if new_value == true:
		val_a = current_val
		current_val = digit
		disp.text = str(current_val)
		new_value = false
	else:
		current_val = current_val * 10 + digit
		disp.text = str(current_val)

func clear(_unhandled_bool: bool = false) -> void: ## Sets current and displayed value to 0 and cancels current operation, if any
	current_val = 0
	val_a = 0
	disp.text = str(current_val)
	current_operation = operators.IDLE

func operator(button: Button) -> void: ## Sets the next operation to be performed
	if current_operation != operators.IDLE:
		evaluate(true)
		
	new_value = true
	
	if button.name == "addition":
		current_operation = operators.ADDITION
	elif button.name == "subtraction":
		current_operation = operators.SUBTRACTION
	elif button.name == "multiplication":
		current_operation = operators.MULTIPLICATION
	elif button.name == "division":
		current_operation = operators.DIVISION
	else:
		current_operation = operators.IDLE
	
	SignalBus.operation_begun.emit()

func add(qty: int) -> void:
	current_val += qty
	disp.text = str(current_val)

func subtract(a: int, b: int = 0) -> void:
	current_val = a - b
	disp.text = str(current_val)

func multiply(qty: int) -> void:
	current_val *= qty
	disp.text = str(current_val)
	
func divide(numerator: int, divisor: int = 1) -> void:
	current_val = numerator / divisor
	disp.text = str(current_val)

func evaluate(is_operator: bool) -> void: ## Evaluates the next operation. Use is_operator = true if being performed by any event other than enter key
	if current_operation == operators.IDLE:
		pass
	elif current_operation == operators.ADDITION:
		add(val_a)
	elif current_operation == operators.SUBTRACTION:
		subtract(val_a, current_val)
	elif current_operation == operators.MULTIPLICATION:
		multiply(val_a)
	elif current_operation == operators.DIVISION:
		divide(val_a, current_val)
	SignalBus.score.emit(current_val)
	
	if is_operator == false:
		current_operation = operators.IDLE

func restore_buttons(flash: bool = true) -> void: ## Enables all disabled buttons
	var restored_buttons: Array[Button]
	
	for i in buttons:
		if i.disabled == true:
			restored_buttons.append(i)
			
	for i in ops:
		if i.disabled == true:
			restored_buttons.append(i)
	
	for i in restored_buttons:
		i.disabled = false
		if flash == true:
			flash_button(i, Color(0,1,0,1), false)

func disable_buttons(disabled_buttons: Array[Button], flash: bool = true) -> void: ## Disables an input array of number buttons. Buttons will flash red by default. Set flash to false to disable.
	for button in disabled_buttons:
		button.disabled = true
		if flash == true:
			flash_button(button, Color(1, 0, 0, 1), true)

func disable_operators(disabled_operators: Array[Button], flash: bool = true) -> void: ## Disables an input array of operator buttons
	for button in disabled_operators:
		button.disabled = true
		if flash == true:
			flash_button(button, Color(1, 0, 0, 1), true)

func game_start() -> void:
	current_difficulty = 1
	max_difficulty = 4
	restore_buttons(false)
	disable_buttons(get_random_numbers(), false)
	clear()

func flash_button(object: Node, color: Color, shrink: bool) -> void:
	var tween = create_tween()
	var old_scale: Vector2 = object.scale
	var new_scale: Vector2
	
	if shrink == true:
		new_scale = 0.5 * old_scale
	else:
		new_scale = 1.5 * old_scale
	
	tween.tween_property(object, "modulate", color, 0.1)
	tween.parallel().tween_property(object, "scale", new_scale, 0.1)
	tween.tween_property(object, "modulate", Color(1, 1, 1, 1), 1.5)
	tween.parallel().tween_property(object, "scale", old_scale, 0.1)

func get_random_numbers(qty: int = current_difficulty, maximum: int = max_difficulty) -> Array[Button]:
	var selected_buttons: Array[Button]
	var progress: int = 0
	
	if maximum < 1:
		maximum = 1
	
	if qty > clamp(maximum, 0, max_difficulty):
		qty = maximum
	
	while progress < qty:
		var current_button = buttons.pick_random()
		if current_button.disabled == true:
			pass
		else:
			current_button.disabled = true
			selected_buttons.append(current_button)
			progress += 1
	
	return selected_buttons

func get_random_operators(qty: int = 0) -> Array[Button]:
	var selected_operators: Array[Button]
	var progress = 0
	
	while progress < qty:
		var current_operator = ops.pick_random()
		if current_operator.disabled == true:
			pass
		else:
			current_operator.disabled = true
			selected_operators.append(current_operator)
			progress += 1
	
	return selected_operators

func get_disabled_numbers() -> Array[Button]:
	var numbers: Array[Button]
	
	for i in buttons:
		if i.disabled == true:
			numbers.append(i)
			
	return numbers
	
func get_disabled_operators() -> Array[Button]:
	var current_operators: Array[Button]
	
	for i in ops:
		if i.disabled == true:
			current_operators.append(i)
	
	return current_operators

func difficulty_increase() -> void:
	current_difficulty += 1
	restore_buttons()
	disable_buttons(get_random_numbers())
