extends Control

# ============================================================
# ⭐ ССЫЛКИ НА УЗЛЫ (UI и плеер)
# ============================================================
@onready var start_button: Button = $MarginContainer/CustomButtom
@onready var voice_player: AudioStreamPlayer = $VoicePlayer
@onready var bear_button: Button = $MarginContainer/VBoxContainer/PersonsContainer/BearButton
@onready var bird_button: Button = $MarginContainer/VBoxContainer/PersonsContainer/BirdButton
@onready var ushastic: Node2D = $MarginContainer/VBoxContainer/PersonsContainer/UshasticContainer/Ushastic
@onready var repeat_button: Button = $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/RepeatButton

# Ссылки на части морковок для прогресс-бара
@onready var body_one: TextureRect = $MarginContainer/VBoxContainer/PanelContainer/CarrotContainer/HBoxContainer/Carrot1/body
@onready var tail_one: TextureRect = $MarginContainer/VBoxContainer/PanelContainer/CarrotContainer/HBoxContainer/Carrot1/tail
@onready var body_two: TextureRect = $MarginContainer/VBoxContainer/PanelContainer/CarrotContainer/HBoxContainer/Carrot2/body
@onready var tail_two: TextureRect = $MarginContainer/VBoxContainer/PanelContainer/CarrotContainer/HBoxContainer/Carrot2/tail
@onready var body_three: TextureRect = $MarginContainer/VBoxContainer/PanelContainer/CarrotContainer/HBoxContainer/Carrot3/body
@onready var tail_three: TextureRect = $MarginContainer/VBoxContainer/PanelContainer/CarrotContainer/HBoxContainer/Carrot3/tail

# ============================================================
# ⭐ ПЕРЕМЕННЫЕ ДЛЯ ЗВУКОВ (Паттерн "Shuffle Bag")
# ============================================================
# Массивы хранят все загруженные аудиофайлы
var bird_sounds: Array[AudioStream] = [] 
var bear_sounds: Array[AudioStream] = [] 
# Очереди используются для перемешивания (чтобы звуки не повторялись подряд)
var bird_queue: Array[AudioStream] = []  
var bear_queue: Array[AudioStream] = []  

# ============================================================
# ⭐ ПЕРЕМЕННЫЕ ДЛЯ ЛОГИКИ УРОКА
# ============================================================
var lesson_stage: int = 0 # 0 - знакомство (туториал), 1 - основное задание (викторина)

# Переменные для умного чередования персонажей
var character_queue: Array[String] = [] # Очередь ("bird" или "bear")
var last_character: String = ""         # Кто был загадан в прошлый раз
var repeat_count: int = 0               # Сколько раз подряд он выпал
var current_target: String = ""         # Кого сейчас нужно угадать

var last_animal_sound: AudioStream = null # Хранит последний звук животного (для кнопки "Повторить")

# Переменные для сбора морковок
var carrots_collected: int = 0 
const MAX_CARROWS: int = 3     

# ============================================================
# ⭐ КОНСТАНТЫ ЦВЕТОВ
# ============================================================
# Цвета для блокировки кнопок
const COLOR_LOCKED = Color(0.513, 0.544, 0.746, 1.0) # Синевато-серый
const COLOR_NORMAL = Color(1, 1, 1)                   # Оригинальный цвет

# Цвета для морковок (работают, если исходные картинки в Figma белые)
const BODY_EMPTY_COLOR = Color(1.0, 0.6, 0.0, 0.3)   # Бледно-оранжевый (30% прозрачности)
const TAIL_EMPTY_COLOR = Color(0.2, 0.8, 0.2, 0.3)   # Бледно-зеленый
const BODY_FILLED_COLOR = Color(1.0, 0.6, 0.0, 1.0)  # Яркий оранжевый
const TAIL_FILLED_COLOR = Color(0.2, 0.8, 0.2, 1.0)  # Яркий зеленый

# ============================================================
# ⭐ ИНИЦИАЛИЗАЦИЯ
# ============================================================
func _ready():
	# Подключаем сигналы кнопок к функциям
	start_button.pressed.connect(_on_start_button_pressed)
	bird_button.pressed.connect(_on_bird_button_pressed)
	bear_button.pressed.connect(_on_bear_button_pressed)
	repeat_button.pressed.connect(_on_repeat_button_pressed)
	
	# При старте блокируем персонажей
	set_button_lock_state(bear_button, true)
	set_button_lock_state(bird_button, true)
	
	# Загружаем все 11 звуков для каждой птички и мишки
	for i in range(1, 12):
		var path = "res://assets/sounds/lesson1/task/%dbird.mp3" % i
		bird_sounds.append(load(path))
		var path_bear = "res://assets/sounds/lesson1/task/%dbear.mp3" % i
		bear_sounds.append(load(path_bear))
		
	# Делаем морковки "пустыми" при старте игры
	body_one.modulate = BODY_EMPTY_COLOR
	tail_one.modulate = TAIL_EMPTY_COLOR
	body_two.modulate = BODY_EMPTY_COLOR
	tail_two.modulate = TAIL_EMPTY_COLOR
	body_three.modulate = BODY_EMPTY_COLOR
	tail_three.modulate = TAIL_EMPTY_COLOR

# ============================================================
# ⭐ ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
# ============================================================

# Воспроизводит голос Ушастика и ждет окончания
func play_ushastik_voice(file_name: String):
	voice_player.stream = load("res://assets/sounds/lesson1/" + file_name)
	voice_player.play()
	await voice_player.finished

# Воспроизводит случайный звук птички и запоминает его
func play_random_bird_sound():
	last_animal_sound = get_random_bird_sound()
	voice_player.stream = last_animal_sound
	voice_player.play()
	await voice_player.finished
	
# Воспроизводит случайный звук мишки и запоминает его
func play_random_bear_sound():
	last_animal_sound = get_random_bear_sound()
	voice_player.stream = last_animal_sound
	voice_player.play()
	await voice_player.finished

# Пауза между репликами (1 секунда)
func pause_between_replica():
	await get_tree().create_timer(1.0).timeout 

# ⭐ ЛОГИКА SHUFFLE BAG (достает звук из мешка, если мешок пуст - перемешивает)
func get_random_bird_sound() -> AudioStream:
	if bird_queue.is_empty():
		bird_queue = bird_sounds.duplicate() # Копируем массив
		bird_queue.shuffle()                 # Перемешиваем
	return bird_queue.pop_back()             # Достаем последний
	
func get_random_bear_sound() -> AudioStream:
	if bear_queue.is_empty():
		bear_queue = bear_sounds.duplicate()
		bear_queue.shuffle()
	return bear_queue.pop_back()

# Универсальная функция: блокирует кнопку и красит её в серый
func set_button_lock_state(button: Control, is_locked: bool):
	button.disabled = is_locked 
	button.modulate = COLOR_LOCKED if is_locked else COLOR_NORMAL

# Повторяет последний прозвучавший звук животного
func repeat_last_sound():
	if last_animal_sound != null:
		voice_player.stream = last_animal_sound
		voice_player.play()
		await voice_player.finished
		
# Закрашивает следующую морковку (в зависимости от того, сколько уже собрано)
func color_next_carrot():
	if carrots_collected == 0:
		body_one.modulate = BODY_FILLED_COLOR
		tail_one.modulate = TAIL_FILLED_COLOR
		animate_carrot_pop(body_one.get_parent()) # ⭐ Анимация первой морковки
	elif carrots_collected == 1:
		body_two.modulate = BODY_FILLED_COLOR
		tail_two.modulate = TAIL_FILLED_COLOR
		animate_carrot_pop(body_two.get_parent()) # ⭐ Анимация второй морковки
	elif carrots_collected == 2:
		body_three.modulate = BODY_FILLED_COLOR
		tail_three.modulate = TAIL_FILLED_COLOR
		animate_carrot_pop(body_three.get_parent()) # ⭐ Анимация третьей морковки
	
	carrots_collected += 1
	print("Закрашено морковок: ", carrots_collected)
	
# ⭐ Функция для эффекта "Пружинки" (Pop effect)
func animate_carrot_pop(carrot_node: Control):
	# Обязательно ставим точку масштабирования в центр морковки, 
	# иначе она будет расти вправо-вниз
	carrot_node.pivot_offset = carrot_node.size / 2
	
	var tween = create_tween()
	# 1. Быстро увеличиваем морковку (за 0.15 сек до 120%)
	tween.tween_property(carrot_node, "scale", Vector2(1.2, 1.2), 0.15)\
		.set_trans(Tween.TRANS_SINE)
	
	# 2. Плавно возвращаем обратно, с легким отскоком (Ease Out)
	tween.tween_property(carrot_node, "scale", Vector2(1.0, 1.0), 0.25)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# ============================================================
# ⭐ СЦЕНАРИЙ УРОКА (Обработчики кнопок)
# ============================================================

func _on_start_button_pressed():
	start_button.hide() 
	
	# ЭТАП 0: Знакомство
	if lesson_stage == 0:
		await play_ushastik_voice("1Ru.mp3")
		await pause_between_replica()
		await play_ushastik_voice("2Ru.mp3")
		await play_random_bird_sound() # Демонстрация: поет птичка
		set_button_lock_state(bird_button, false) # Разблокируем птичку
		
	# ЭТАП 1: Задание
	elif lesson_stage == 1:
		print("Начинаем задание!")
		await _on_task_button() # Ушастик говорит задание
		await guess_sound()     # Загадываем первый звук
	
func _on_bird_button_pressed():
	# ЭТАП 0: Ребенок нажимает на птичку для знакомства
	if lesson_stage == 0:
		print("Ребенок нажал на Птичку!")
		if not voice_player.playing:
			set_button_lock_state(bird_button, true)
			bird_button.get_node("Bird").play_swing()
			await play_random_bird_sound()
			await pause_between_replica()
			await play_ushastik_voice("3Ru.mp3")
			await play_random_bear_sound() # Демонстрация: поет мишка
			set_button_lock_state(bear_button, false) # Разблокируем мишку
			
	# ЭТАП 1: Ребенок дает ОТВЕТ в викторине
	elif lesson_stage == 1:
		await check_answer("bird")
		
func _on_bear_button_pressed():
	# ЭТАП 0: Ребенок нажимает на мишку для знакомства
	if lesson_stage == 0:
		print("Ребенок нажал на Мишку!")
		if not voice_player.playing:
			set_button_lock_state(bear_button, true)
			bear_button.get_node("Bear").play_rotation()
			await play_random_bear_sound()
			await pause_between_replica()
			
			# Переходим к заданию
			lesson_stage = 1
			start_button.text = "Задание"
			start_button.show() # Показываем кнопку "Задание"
			
	# ЭТАП 1: Ребенок дает ОТВЕТ в викторине
	elif lesson_stage == 1:
		await check_answer("bear")

# Ушастик объясняет суть задания
func _on_task_button():
	await play_ushastik_voice("4Ru.mp3")
	
# Кнопка "Повторить звук" (вызывается, если ребенок не расслышал)
func _on_repeat_button_pressed():
	if not voice_player.playing and last_animal_sound != null:
		# Запоминаем, были ли кнопки заблокированы
		var bear_was_locked = bear_button.disabled
		var bird_was_locked = bird_button.disabled
		
		# Блокируем на время повтора
		set_button_lock_state(bear_button, true)
		set_button_lock_state(bird_button, true)
		
		await repeat_last_sound()
		
		# Возвращаем кнопки в исходное состояние
		set_button_lock_state(bear_button, bear_was_locked)
		set_button_lock_state(bird_button, bird_was_locked)
	
# ⭐ ГЛАВНАЯ ФУНКЦИЯ ВИКТОРИНЫ: Загадывает звук
func guess_sound():
	# Блокируем кнопки, чтобы нельзя было нажать во время загадывания
	set_button_lock_state(bear_button, true)
	set_button_lock_state(bird_button, true)
	
	# Узнаем, кто будет петь
	current_target = get_next_character()
	print("Загадан персонаж: ", current_target)
	
	# Проигрываем звук загаданного персонажа
	if current_target == "bird":
		await play_random_bird_sound()
	else:
		await play_random_bear_sound()
		
	# Разблокируем кнопки для ответа
	set_button_lock_state(bear_button, false)
	set_button_lock_state(bird_button, false)

# Умный генератор: кто будет петь? (Защита от 3+ повторов подряд)
func get_next_character() -> String:
	if character_queue.is_empty():
		# Закидываем по 2 птички и 2 мишки
		character_queue = ["bird", "bird", "bear", "bear"]
		character_queue.shuffle()
	
	var next_char: String = character_queue.pop_back()
	
	# Если выпал тот же, кто и 2 раза до этого - принудительно меняем
	if next_char == last_character and repeat_count >= 2:
		next_char = "bear" if last_character == "bird" else "bird"
		character_queue.push_front(last_character)
	
	# Обновляем статистику
	if next_char == last_character:
		repeat_count += 1
	else:
		last_character = next_char
		repeat_count = 1
		
	return next_char
	
# ⭐ ПРОВЕРКА ОТВЕТА РЕБЕНКА
func check_answer(chosen_character: String):
	# Защита: если играет звук, клики игнорируются
	if voice_player.playing:
		return
		
	# Блокируем обе кнопки, чтобы нельзя было нажать дважды
	set_button_lock_state(bear_button, true)
	set_button_lock_state(bird_button, true)
	
	# Визуальный отклик на нажатие (анимация)
	if chosen_character == "bird":
		bird_button.get_node("Bird").play_swing()
	else:
		bear_button.get_node("Bear").play_rotation()
		
	# --- ЕСЛИ ОТВЕТ ПРАВИЛЬНЫЙ ---
	if chosen_character == current_target:
		print("ВЕРНО! Угадал: ", chosen_character)
		
		color_next_carrot() # Закрашиваем морковку
		
		ushastic.jump_ushastic() # Ушастик прыгает от радости
		await play_ushastik_voice("successRu.mp3")
		await pause_between_replica()
		
		# Проверяем, не собрал ли ребенок все 3 морковки (Победа)
		if carrots_collected >= MAX_CARROWS:
			print("УРОК ПРОЙДЕН! Все морковки собраны!")
			# Здесь можно добавить переход на карту:
			# get_tree().change_scene_to_file("res://scenes/WorldMap.tscn")
		else:
			# Если не победил — загадываем следующий звук
			await guess_sound()
			
	# --- ЕСЛИ ОТВЕТ НЕПРАВИЛЬНЫЙ ---
	else:
		print("ОШИБКА! Выбрано: ", chosen_character, ", а загадан был: ", current_target)
		ushastic.play_fail() # Ушастик грустит
		await play_ushastik_voice("failRu.mp3")
		await pause_between_replica()
		
		# Повторяем звук, чтобы ребенок послушал еще раз
		await repeat_last_sound()
		
		# Разблокируем кнопки для новой попытки
		set_button_lock_state(bear_button, false)
		set_button_lock_state(bird_button, false)
