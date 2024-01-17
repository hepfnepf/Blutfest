shader_type canvas_item;


//from https://www.youtube.com/watch?v=SCHdglr35pk

uniform vec2 center;
uniform float force=0.03;
uniform float radius = 0.0;
uniform float thickness= 0.04;

void fragment(){
	
	float ratio = SCREEN_PIXEL_SIZE.x/ SCREEN_PIXEL_SIZE.y;
	
	vec2 scaledUV = (SCREEN_UV-vec2(0.5,0.0)) / vec2(ratio,1.0) + vec2(0.5,0.0);
	float mask = (1.0-smoothstep(radius-0.1, radius,length(scaledUV - center)))*smoothstep(radius-thickness-0.1, radius-thickness,length(scaledUV - center)) ;
	
	vec2 disp = normalize(scaledUV-center) * force*mask;//displacement
	COLOR = texture(SCREEN_TEXTURE,SCREEN_UV-disp);

}
	