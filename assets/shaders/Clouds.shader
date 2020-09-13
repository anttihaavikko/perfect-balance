shader_type canvas_item;

uniform vec4 color : hint_color;
uniform vec2 offset;
uniform float alpha;
uniform float seed;

float hash(vec2 p) {
  return fract(sin(dot(p * 17.17, vec2(14.91, 67.31))) * 4791.9511);
}

float noise(vec2 x) {
  vec2 p = floor(x);
  vec2 f = fract(x);
  f = f * f * (3.0 - 2.0 * f);
  vec2 a = vec2(1.0, 0.0);
  return mix(mix(hash(p + a.yy), hash(p + a.xy), f.x), mix(hash(p + a.yx), hash(p + a.xx), f.x), f.y);
}

float fbm(vec2 x, float freq, float amp) {
  float height = 0.0;
  float amplitude = amp;
  float frequency = freq;
  for (int i = 0; i < 6; i++){
    height += noise(x * frequency) * amplitude;
    amplitude *= 0.5;
    frequency *= 2.0;
  }
  return height;
}

void fragment() {
	COLOR.rgb = color.rgb;
	float disp_x = fbm(SCREEN_UV + vec2(seed + TIME * 0.01), 10.0, 0.1);
	float disp_y = fbm(SCREEN_UV + + vec2(-seed - TIME * 0.01), 10.0, 0.1);
	COLOR.a = step(0.6, fbm(SCREEN_UV + vec2(disp_x, disp_y) + offset, 5.0, 0.5)) * alpha;
}