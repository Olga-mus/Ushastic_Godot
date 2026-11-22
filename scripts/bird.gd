extends Node2D
@onready var anim: AnimationPlayer = $AnimationPlayer

func play_swing():
	# Запускаем анимацию первый раз
	anim.play("swing")
	
	# Ждем, пока она полностью не закончится
	await anim.animation_finished
	
	# Запускаем анимацию второй раз
	anim.play("swing")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
