extends Node2D
@onready var anim: AnimationPlayer = $AnimationPlayer

func play_shake():
	# Запускаем анимацию 
	await play_shake_times(2)

# Универсальная функция для повтора анимации нужное количество раз
func play_shake_times(count: int):
	for i in range(count):
		anim.play("shake")
		await anim.animation_finished
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	pass
