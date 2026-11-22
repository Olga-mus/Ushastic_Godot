extends Control

@onready var start_button: Button = $MarginContainer/CustomButtom
@onready var voice_player: AudioStreamPlayer = $VoicePlayer
@onready var bear_button: Button = $MarginContainer/VBoxContainer/PersonsContainer/BearButton
@onready var bird_button: Button = $MarginContainer/VBoxContainer/PersonsContainer/BirdButton

func _ready():
	# Подключаем нажатие на кнопку
	start_button.pressed.connect(_on_start_button_pressed)
	# ⭐ ПОДКЛЮЧАЕМ НАЖАТИЕ НА ПТИЧКУ
	bird_button.pressed.connect(_on_bird_button_pressed)
	
	# ⭐ БЛОКИРУЕМ ПЕРСОНАЖЕЙ В САМОМ НАЧАЛЕ
	bear_button.set_process_input(false) 
	bird_button.set_process_input(false) 
	
	# Затемняем обе кнопки
	bear_button.modulate = Color(0.5, 0.5, 0.5)
	bird_button.modulate = Color(0.5, 0.5, 0.5)

# Вынесенная функция паузы
func pause_between_replica():
	await get_tree().create_timer(1.0).timeout 

func _on_start_button_pressed():
	start_button.disabled = true
	start_button.hide() 
	
	# ==========================================
	# 1. РЕПЛИКА 1Ru
	# ==========================================
	voice_player.play()
	await voice_player.finished 
	
	# ⭐ Вызываем паузу ПРАВИЛЬНО (с await)
	await pause_between_replica()
	
	# ==========================================
	# 2. РЕПЛИКА 2Ru
	# ==========================================
	voice_player.stream = load("res://assets/sounds/lesson1/2Ru.mp3")
	voice_player.play()
	await voice_player.finished 
	
	# ==========================================
	# 3. ЗВУК ПТИЧКИ 1bird
	# ==========================================
	voice_player.stream = load("res://assets/sounds/lesson1/task/1bird.mp3")
	voice_player.play()
	
	# Ждем, пока птичка полностью допоет
	await voice_player.finished 
	
	#  РАЗБЛОКИРОВАЕМ ПТИЧКУ (и цвет, и клик) в один момент
	bird_button.modulate = Color(1, 1, 1) 
	bird_button.set_process_input(true)
	
# ⭐ НОВАЯ ФУНКЦИЯ: Срабатывает, когда ребенок нажимает на Птичку
func _on_bird_button_pressed():
	print("Ребенок нажал на Птичку!")
	
	# Проверяем, не играет ли уже звук, чтобы не было наложения
	if not voice_player.playing:
		# Загружаем звук птички и включаем его
		voice_player.stream = load("res://assets/sounds/lesson1/task/1bird.mp3")
		voice_player.play()
	# ⭐ ГЛАВНАЯ МАГИЯ ЗДЕСЬ:
	# 1. bird_button.get_node("Bird") — мы заходим внутрь кнопки и находим там узел Bird
	# 2. .play_swing() — вызываем функцию, которую мы написали в bird.gd
	bird_button.get_node("Bird").play_swing()
