extends SubViewportContainer

var shake_strength: float = 0.0
var shake_timer: float = 0.0

@onready var origin_pos = position 

var noise = FastNoiseLite.new()
var noise_i: float = 0.0

func _ready():
	noise.seed = randi()
	noise.frequency = 0.5

func _physics_process(delta: float) -> void:
	if shake_timer > 0:
		shake_timer -= delta
		noise_i += delta * 50.0
		
		var current_strength = shake_strength #* (shake_timer / 1.0)
		
		position.x = noise.get_noise_1d(noise_i) * current_strength
		position.y = noise.get_noise_1d(noise_i + 100.0) * current_strength
	else:
		position.x = 0
		position.y = 0

func camera_shake(strength: float = 120.0, duration: float = 0.56):
	shake_strength = strength
	shake_timer = duration
