shader_type canvas_item;
varying smooth vec2 coord;

const vec2 bayer2[2] = {
	vec2(0., 2.),
	vec2(3., 1.)
};

const vec4 bayer4[4] = {
	vec4(0, 8, 2, 10),
	vec4(12, 4, 14, 6),
	vec4(3, 11, 1, 9),
	vec4(15, 7, 13, 5)
};


const float ditherMatrixSizeB2 = 2.;
const float ditherMatrixSizeB4 = 4.;

const float offset = 0.5; 

void vertex(){
	coord = VERTEX;
}

void fragment() {
	vec2 calculatedBayer2[2] = {
		bayer2[0] / ditherMatrixSizeB2,
		bayer2[1] / ditherMatrixSizeB2
	};
	
	vec4 calculatedBayer4[4] = {
		(bayer4[0] / ditherMatrixSizeB4),	
		(bayer4[1] / ditherMatrixSizeB4),	
		(bayer4[2] / ditherMatrixSizeB4),	
		(bayer4[3] / ditherMatrixSizeB4)	
	};
	
	ivec2 bayerCoords = ivec2(
		int(mod(abs(FRAGCOORD.x), ditherMatrixSizeB4)), 
		int(mod(abs(FRAGCOORD.y), ditherMatrixSizeB4))
	);
	
	float M = calculatedBayer4[bayerCoords.x][bayerCoords.y] - offset;
	float allowedChannelValues = 32.;
	float r = 255. / allowedChannelValues / (ditherMatrixSizeB4 * ditherMatrixSizeB4);
	
	vec3 transformedColor;
	transformedColor.r = COLOR.r + r * M;
	transformedColor.g = COLOR.g + r * M;
	transformedColor.b = COLOR.b + r * M;


	
	COLOR.rgb *= transformedColor;
}
