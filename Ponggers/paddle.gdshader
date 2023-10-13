shader_type canvas_item;

varying smooth float y;
void vertex(){
	y = VERTEX.y;
}

void fragment() {
	// Place fragment code here.
	float newCol = mix(1., .1, abs(y));
	COLOR.rgb = vec3(newCol);
}
