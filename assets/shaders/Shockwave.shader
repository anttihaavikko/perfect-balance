shader_type canvas_item;

uniform vec2 origin = vec2(0.5, 0.5);
uniform float amount = 0.0;
uniform float size = 0.0;
uniform float feather = 0.05;
uniform float thickness = 0.03;

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = vec2((SCREEN_UV.x - 0.5) / ratio + 0.5, SCREEN_UV.y);
	vec2 scaledOrigin = vec2((origin.x - 0.5) / ratio + 0.5, origin.y);
	scaledUV = SCREEN_UV;
	scaledOrigin = origin;
	float outer = 1.0 - smoothstep(size - feather, size, length(scaledUV - scaledOrigin));
	float inner = smoothstep(size - feather - thickness, size - thickness, length(scaledUV - scaledOrigin));
	float mask = outer * inner;
	vec2 disp = normalize(scaledUV - scaledOrigin) * amount * mask;
	float shift = 0.001;
	COLOR.r = texture(SCREEN_TEXTURE, scaledUV + vec2(shift, 0) * mask - disp).r;
	COLOR.g = texture(SCREEN_TEXTURE, scaledUV - disp).g;
	COLOR.b = texture(SCREEN_TEXTURE, scaledUV - vec2(shift, 0) * mask - disp).b;
	//COLOR.rgb = vec3(mask);
	//COLOR.a = 0.5;
}