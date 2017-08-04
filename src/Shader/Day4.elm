module Shader.Day4 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    // Elm doesn't seem to support #define so just using a const instead
    const float PI = 3.14159265359;

    void main () {
        // Use 0.0 to 1.0 coordinate system for both axis
        vec2 r = gl_FragCoord.xy / u_resolution.xy;

        vec3 blue = vec3(0, 0.627, 0.690);
        vec3 red = vec3(0.8, 0.2, 0.247);
        vec3 yellow = vec3(0.862, 0.584, 0.003);

        // Normalize time so it's always a value between 0.0 and 1.0
        float t = abs(fract(u_time * 0.3) * 2.0 - 1.0);
        // Apply SineInOut easing to the t value
        t = -0.5 * (cos(PI * t) - 1.0);
        // Size of the gradient: between 0.01 and 0.2
        float g = 0.19 * t + 0.01;
        // Make animation go to max 0.7 instead of 1.0
        float a = t * 0.7;

        // red/blue animated gradient
        vec3 color = mix(blue, red, smoothstep(a - g, a + g, r.y));
        // Yellow gradient at top
        color = mix(color, yellow, smoothstep(0.45, 0.8, r.y) * (1.0 - t));

        gl_FragColor = vec4(color, 1.0);
    }

|]
