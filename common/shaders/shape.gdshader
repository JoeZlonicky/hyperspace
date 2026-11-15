shader_type canvas_item;

uniform vec4 primary : source_color;
uniform int vertices = 3;

// Adapted from https://thebookofshaders.com/07/
void fragment() {
 	// Remap the space to -1. to 1.
 	vec2 st = UV * 2.-1.;

 	// Number of sides of your shape
 	int N = vertices;

 	// Angle and radius from the current pixel
 	float a = atan(st.x, -st.y)+PI;
 	float r = 2.0 * PI / float(N);

 	// Shaping function that modulate the distance
 	float d = cos(floor(0.5 + a / r) * r - a) * length(st);
 	vec3 color = vec3(1.0 - smoothstep(0.4, 0.41, d));
	float alpha = length(color) < 1.0 ? 0.0 : 1.0;
 	COLOR = primary * vec4(color, alpha);
}