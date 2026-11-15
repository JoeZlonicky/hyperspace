class_name BackgroundLayer
extends CanvasLayer


var progress: float = 0.0
var progress_speed: float = 75.0

@onready var layer_parallax: Dictionary[TextureRect, float] = {
	%Background: 0.75,
	%Foreground: 1.0
}


func _process(delta: float) -> void:
	progress += progress_speed * delta
	for l in layer_parallax:
		var parallax := layer_parallax[l]
		l.set_instance_shader_parameter("offset", 
			Vector2(progress * parallax, 0.25))
