extends HBoxContainer

@onready var bear_button: Button = $BearButton
@onready var bird_button: Button = $BirdButton
@onready var repeat_button: Button = $"../PanelContainer/HBoxContainer/RepeatButton"
@onready var home_button: Button = $"../PanelContainer/HBoxContainer/HomeButton"
@onready var task_button: Button = $"../../CustomButtom"

func _ready() -> void:
	# 1. НАСТРОЙКА БОЛЬШИХ КНОПОК-ПЕРСОНАЖЕЙ (Размер 500х500, центр 250х250)
	for btn in [bear_button, bird_button]:
		btn.custom_minimum_size = Vector2(500, 500)
		btn.pivot_offset = Vector2(250, 250)
		_freeze_button_style(btn)
		
	# 2. НАСТРОЙКА МАЛЕНЬКИХ КНОПОК ИНТЕРФЕЙСА (Размер 200х200, центр 100x100)
	for btn in [repeat_button, home_button]:
		btn.custom_minimum_size = Vector2(200, 200)
		btn.pivot_offset = Vector2(100, 100)
		_freeze_button_style(btn)
		
	# 3. НАСТРОЙКА ВЫТЯНУТОЙ КНОПКИ «ЗАДАНИЕ» (Размер 400х120, центр 200х60)
	task_button.custom_minimum_size = Vector2(400, 120)
	task_button.pivot_offset = Vector2(200, 60)
	_freeze_button_style(task_button)
			
	# 4. ПОДКЛЮЧЕНИЕ АНИМАЦИИ НАЖАТИЯ ДЛЯ ВСЕХ КНОПОК
	bear_button.button_down.connect(func(): _animate_scale(bear_button, 0.93))
	bear_button.button_up.connect(func(): _animate_scale(bear_button, 1.0))
	
	bird_button.button_down.connect(func(): _animate_scale(bird_button, 0.93))
	bird_button.button_up.connect(func(): _animate_scale(bird_button, 1.0))
	
	repeat_button.button_down.connect(func(): _animate_scale(repeat_button, 0.93))
	repeat_button.button_up.connect(func(): _animate_scale(repeat_button, 1.0))
	
	home_button.button_down.connect(func(): _animate_scale(home_button, 0.93))
	home_button.button_up.connect(func(): _animate_scale(home_button, 1.0))
	
	task_button.button_down.connect(func(): _animate_scale(task_button, 0.93))
	task_button.button_up.connect(func(): _animate_scale(task_button, 1.0))
	
	# 5. ПОДКЛЮЧЕНИЕ ФУНКЦИЙ КЛИКА
	bear_button.pressed.connect(_on_bear_pressed)
	bird_button.pressed.connect(_on_bird_pressed)
	repeat_button.pressed.connect(_on_replay_pressed)
	home_button.pressed.connect(_on_home_pressed)
	task_button.pressed.connect(_on_task_pressed)

# Функции обработки нажатий:
func _on_bear_pressed() -> void:
	print("Нажали на мишку в норке!")

func _on_bird_pressed() -> void:
	print("Нажали на птичку на дереве!")

func _on_replay_pressed() -> void:
	print("Нажали кнопку: Повтор")

func _on_home_pressed() -> void:
	print("Нажали кнопку: Домой")

func _on_task_pressed() -> void:
	print("Нажали кнопку: Задание")

# Вспомогательная функция, чтобы кнопки не мигали серым на смартфонах
func _freeze_button_style(btn: Button) -> void:
	var style = btn.get_theme_stylebox("normal").duplicate()
	for state in ["normal", "pressed", "hover", "focus"]:
		btn.add_theme_stylebox_override(state, style)

# Универсальная функция плавного уменьшения кнопки под пальцем
func _animate_scale(button: Button, target_scale: float) -> void:
	var button_tween = create_tween()
	button_tween.tween_property(button, "scale", Vector2(target_scale, target_scale), 0.08)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
