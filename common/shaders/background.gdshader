shader_type canvas_item;

uniform vec4 bg : source_color;
uniform vec4 primary : source_color;

uniform vec2 size = vec2(480, 270);
uniform int spacing = 20;
uniform float lineWidth = 1.0;

instance uniform vec2 offset = vec2(0, 0);
instance uniform float progress = 0.0;

vec4 getColor(vec2 uv) {
	vec2 pos = size * uv;
	pos += offset;
	
	int x = int(pos.x);
	if (mod(pos.x, float(spacing)) <= lineWidth || mod(pos.y, float(spacing)) <= lineWidth) {
		return primary;
	}
	return bg;
}

void fragment() {
	COLOR = getColor(UV);
}
