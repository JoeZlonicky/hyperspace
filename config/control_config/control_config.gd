class_name ControlConfig
extends Resource


@export_custom(PROPERTY_HINT_INPUT_NAME, "") var up_input: StringName
@export_custom(PROPERTY_HINT_INPUT_NAME, "") var right_input: StringName
@export_custom(PROPERTY_HINT_INPUT_NAME, "") var down_input: StringName
@export_custom(PROPERTY_HINT_INPUT_NAME, "") var left_input: StringName
@export_custom(PROPERTY_HINT_INPUT_NAME, "") var shoot_input: StringName


func is_shoot_pressed() -> bool:
	if not shoot_input:
		return false
	return Input.is_action_pressed(shoot_input)


func get_movement_vector() -> Vector2:
	return Input.get_vector(left_input, right_input, up_input, down_input)
