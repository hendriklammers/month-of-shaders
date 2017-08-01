module Shader.Day1 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms {}
shader =
    [glsl|

    precision mediump float;

    // Contains the width and height of the screen in pixels
    uniform vec2 u_resolution;
    // Playback time in seconds
    uniform float u_time;

    // Returns a float indicating whether the coord (uv) is inside (1.0) or outside (0.0) the circle
    float circle(vec2 uv, vec2 center, float radius) {
        // Distance from current coordinate to center
        float dist = length(uv - center);
        // Using smoothstep to add antialiasing
        return 1.0 - smoothstep(radius - 0.002, radius + 0.002, dist);
    }

    void main () {
        // Use cartesian coordinate system
        vec2 uv = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;

        vec3 red = vec3(0.8, 0.0, 0.0);
        vec3 green = vec3(0.0, 0.8, 0.0);
        vec3 blue = vec3(0.0, 0.0, 0.8);
        vec3 color = vec3(0.0);

        // Draw circles in center of screen and use the time uniform to animate the radius
        color = mix(color, blue, circle(uv, vec2(0.0), abs(sin(u_time + 0.3)) * 0.25 + 0.05));
        color = mix(color, green, circle(uv, vec2(0.0), abs(sin(u_time + 0.15)) * 0.15 + 0.05));
        color = mix(color, red, circle(uv, vec2(0.0), abs(sin(u_time)) * 0.05 + 0.05));

        gl_FragColor = vec4(color, 1.0);
    }

|]
