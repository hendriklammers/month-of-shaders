module Shader.Day11 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform vec2 u_mouse;
    uniform float u_time;

    const float PI = 3.14159265359;

    vec2 mapUV(vec2 coord) {
        return (2.0 * coord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
    }

    void main () {
        vec2 uv = mapUV(gl_FragCoord.xy);
        // map mouse position to uv coordinates
        vec2 m = mapUV(u_mouse.xy);

        // normalize time
        float t = abs(fract(u_time * 0.8) * 2.0 - 1.0);
        t *= t * t;

        // Move coordinates based on mouse position
        vec2 p = uv + m * 0.1;
        // Create circle shapes and scale down
        float f = length(cos(p * 18.0)) * 2.0;

        // Amount of variation to be added to the size of the distance field
        float r = t * 0.8 + 0.13;
        // Circular distance field that follows mouse
        f *= pow(distance(uv, m) * 3.7 + r, 2.0);

        vec3 c = vec3(1.0 - smoothstep(f, 0.0, 0.5));
        gl_FragColor = vec4(c, 1.0);}

|]
