module Shader.Day8 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    const float PI = 3.14159265359;

    void main() {
        vec2 uv = (2.0 * gl_FragCoord.xy - u_resolution);
        uv /= min(u_resolution.x, u_resolution.y);

        // Create 4 circles moving in a circular motion
        float r = 0.35; // animation radius
        float s = 2.6; // size
        float c1 = length(uv - vec2(sin(u_time * 0.808), cos(u_time * 1.426)) * r) * s;
        float c2 = length(uv - vec2(sin(u_time * 1.426 + PI * 0.5), cos(u_time * 0.894 + PI * 0.5)) * r) * s;
        float c3 = length(uv - vec2(sin(u_time * 1.164 + PI), cos(u_time * 1.316 + PI)) * r) * s;
        float c4 = length(uv - vec2(sin(u_time * 1.278 + PI * 1.5), cos(u_time * 1.074 + PI * 1.5)) * r) * s;
        float c = c1 * c2 * c3 * c4;

        // Square distance field
        float d = length(max(abs(uv.x), abs(uv.y)) * 1.944) + 0.12;

        vec3 color = vec3(smoothstep(0.2, c / d, min(c, d)));
        gl_FragColor = vec4(color,1.0);

    }

|]
