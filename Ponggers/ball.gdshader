shader_type canvas_item;

uniform float u_hit = 1.;
uniform float u_speed = 5.;

void vertex(){
	VERTEX *= mix(.6, .7,sin(TIME * u_speed)) * u_hit;
}

void fragment() {
	// Place fragment code here.
}
