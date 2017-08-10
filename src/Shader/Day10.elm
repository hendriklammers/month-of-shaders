module Shader.Day10 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    void main () {
        vec2 uv = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
        float t = sin(u_time * 1.2) * 0.3;
        // Use time to position 2 circles
        float c1 = length(uv - t);
        float c2 = length(uv + t);
        // Mix the 2 circular distance fields
        float c = smoothstep(0.07, c1, c2);
        vec3 color = vec3(c);
        // vignette
        color = mix(color, vec3(0.0), (0.2 * pow(length(uv), 2.0)));
        gl_FragColor = vec4(color, 1.0);
    }

|]
