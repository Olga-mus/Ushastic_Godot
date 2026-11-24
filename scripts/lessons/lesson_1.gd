extends Control

@onready var start_button: Button = $MarginContainer/CustomButtom
@onready var voice_player: AudioStreamPlayer = $VoicePlayer
@onready var bear_button: Button = $MarginContainer/VBoxContainer/PersonsContainer/BearButton
@onready var bird_button: Button = $MarginContainer/VBoxContainer/PersonsContainer/BirdButton

var bird_sounds: Array[AudioStream] = [] 
var bird_queue: Array[AudioStream] = []  
var bear_sounds: Array[AudioStream] = [] 
var bear_queue: Array[AudioStream] = []  

const COLOR_LOCKED = Color(0.513, 0.544, 0.746, 1.0) 
const COLOR_NORMAL = Color(1, 1, 1)       

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	bird_button.pressed.connect(_on_bird_button_pressed)
	bear_button.pressed.connect(_on_bear_button_pressed)

	set_button_lock_state(bear_button, true)
	set_button_lock_state(bird_button, true)
	
	for i in range(1, 12):
		var path = "res://assets/sounds/lesson1/task/%dbird.mp3" % i
		bird_sounds.append(load(path))
	print("Загружено звуков птичек: ", bird_sounds.size())
	
	for i in range(1, 12):
		var path = "res://assets/sounds/lesson1/task/%dbear.mp3" % i
		bear_sounds.append(load(path))
	print("Загружено звуков мишек: ", bear_sounds.size())

# ============================================================
# ⭐ ФУНКЦИИ ДЕЙСТВИЙ (Что умеют персонажи)
# ============================================================

# Ушастик говорит
func play_ushastik_voice(file_name: String):
	voice_player.stream = load("res://assets/sounds/lesson1/" + file_name)
	voice_player.play()
	await voice_player.finished

# Птичка поет случайную песню (и ждет окончания)
func play_random_bird_sound():
	voice_player.stream = get_random_bird_sound()
	voice_player.play()
	await voice_player.finished
	
# Мишка поет случайную песню (и ждет окончания)
func play_random_bear_sound():
	voice_player.stream = get_random_bear_sound()
	voice_player.play()
	await voice_player.finished

# Пауза между репликами
func pause_between_replica():
	await get_tree().create_timer(1.0).timeout 

# Логика "мешка" для перемешивания птичек
func get_random_bird_sound() -> AudioStream:
	if bird_queue.is_empty():
		bird_queue = bird_sounds.duplicate()
		bird_queue.shuffle()
	return bird_queue.pop_back()
	
# Логика "мешка" для перемешивания мишек
func get_random_bear_sound() -> AudioStream:
	if bear_queue.is_empty():
		bear_queue = bear_sounds.duplicate()
		bear_queue.shuffle()
	return bear_queue.pop_back()

# Универсальная блокировка кнопок
func set_button_lock_state(button: Control, is_locked: bool):
	button.disabled = is_locked 
	button.modulate = COLOR_LOCKED if is_locked else COLOR_NORMAL


# ============================================================
# ⭐ СЦЕНАРИЙ УРОКА (Читается как книга)
# ============================================================

func _on_start_button_pressed():
	start_button.hide() 
	
	# 1. Приветствие
	await play_ushastik_voice("1Ru.mp3")
	await pause_between_replica()
	
	# 2. Инструкция
	await play_ushastik_voice("2Ru.mp3")
	
	# 3. Демонстрация (Птичка поет)
	await play_random_bird_sound()
	
	# Разблокируем птичку для ребенка
	set_button_lock_state(bird_button, false)
	
# ⭐ НАЖАТИЕ НА ПТИЧКУ
func _on_bird_button_pressed():
	print("Ребенок нажал на Птичку!")
	
	if not voice_player.playing:
		set_button_lock_state(bird_button, true)
		
		# Птичка машет крыльями
		bird_button.get_node("Bird").play_swing()
		
		# Птичка поет (ждем окончания)
		await play_random_bird_sound()
		
		await pause_between_replica()
		
		# 4. Ушастик знакомит с Мишкой
		await play_ushastik_voice("3Ru.mp3")
		
		# 5. Демонстрация (Мишка поет)
		await play_random_bear_sound()
		
		# Разблокируем Мишку для ребенка
		set_button_lock_state(bear_button, false)
		
	# ⭐ НАЖАТИЕ НА МИШКУ
func _on_bear_button_pressed():
	print("Ребенок нажал на Мишку!")
	
	if not voice_player.playing:
		set_button_lock_state(bear_button, true)
		
		# Мишка поворачивается
		bear_button.get_node("Bear").play_rotation()
		
		# Мишка поет (ждем окончания)
		await play_random_bear_sound()
		
		await pause_between_replica()
		
		# 4. Ушастик знакомит с Мишкой
		#await play_ushastik_voice("4Ru.mp3")
