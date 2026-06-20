shader_type canvas_item;

const vec2 CENTER = vec2(0.5);
uniform sampler2D screen_texture : hint_screen_texture;
uniform vec2 custom_center;

group_uniforms VignetteSettings;
uniform sampler2D vignette_gradient;
uniform float circle_or_ellipse : hint_range(0.0,1.0,1.0) = 0.0;
uniform float vignette_strength : hint_range(0.0,10.0) = 0.5;
uniform float vignette_spread : hint_range(1.0,5.0) = 1.0;


void fragment() {
	
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	vec2 circle_or_ellipse_uv = scaledUV * circle_or_ellipse + UV * (1.0-circle_or_ellipse);
	vec2 scaledCustomCenter = (custom_center - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	vec2 circle_or_ellipse_center =  scaledCustomCenter * circle_or_ellipse + CENTER * (1.0-circle_or_ellipse);
	
	vec4 vignette_mask = texture(vignette_gradient, vec2(
	pow(min(1.0,distance(circle_or_ellipse_uv , circle_or_ellipse_center)) * vignette_strength, vignette_spread),
	 0.5));
	
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	
	COLOR = screen_color * vignette_mask ;
}
