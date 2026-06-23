shader_type canvas_item;

uniform float offset = 0.0;
uniform sampler2D spinnerTexture;

void fragment() {
	vec2 uv = UV.xy;

	if(uv.y < 0.02 || uv.y > 0.95){
		COLOR.a = 0.0;
	} else {
		uv.y = modf(uv.y + offset, uv.y);
		COLOR = texture(spinnerTexture, uv);
	}
}
