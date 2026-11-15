shader_type canvas_item;

instance uniform vec4 bg_color : source_color;
instance uniform vec4 outline_color : source_color;

instance uniform vec2 size = vec2(25, 25);
instance uniform float outline_width = 5;

varying flat vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec2 pos = size * UV;
	
	if (pos.x < outline_width || size.x - pos.x < outline_width || pos.y < outline_width || size.y - pos.y < outline_width) {
		COLOR = outline_color * modulate;
	} else {
		COLOR = bg_color * modulate;
	}
}