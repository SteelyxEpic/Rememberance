shader_type canvas_item;

// Allows you to dynamically control static intensity from the Inspector
uniform float static_intensity : hint_range(0.0, 1.0) = 0.5;

// Pseudo-random number generator function
float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    // Generate white noise based on screen coordinates modulated by time
    // So the noise cycles rapidly every single frame
    float noise = random(UV * TIME);
    
    // Mix the screen background color or a solid color with the noise
    // If you want a full-screen blackout static, use vec4(noise, noise, noise, 1.0)
    vec4 static_color = vec4(vec3(noise), static_intensity);
    
    COLOR = static_color;
}
