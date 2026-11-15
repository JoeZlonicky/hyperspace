shader_type canvas_item;

uniform vec4 bg : source_color;
uniform vec4 primary : source_color;
uniform vec4 secondary : source_color;

uniform vec2 size = vec2(480, 270);
uniform int primary_spacing = 20;
uniform int secondary_spacing = 10;
uniform float primary_width = 1.0;
uniform float secondary_width = 0.5;

instance uniform vec2 offset = vec2(0.5, 0.5);
instance uniform float progress = 0.0;

vec4 getColor(vec2 uv) {
	vec2 pos = size * uv;
	pos.y += progress;
	
	int x = int(pos.x);
	if (mod(pos.x, float(primary_spacing)) <= primary_width || mod(pos.y, float(primary_spacing)) <= primary_width) {
		return primary;
	}
	if (mod(pos.y, 10) <= secondary_width || mod(pos.x, 10) <= secondary_width) {
		return secondary;
	}
	
	//if (mod(pos.y, primary_spacing) <= primary_width || mod(pos.x, primary_spacing) <= primary_width) {
		//return primary;
	//}
	//if (mod(pos.y, secondary_spacing) <= secondary_width || mod(pos.x, secondary_spacing) <= secondary_width) {
		//return secondary;
	//}
	
	return bg;
}

void fragment() {
	COLOR = getColor(UV);
}
