module Shader.Day7 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    void main () {
        vec2 uv = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy);
        uv = uv / min(u_resolution.y, u_resolution.x);
        float speed = u_time * 2.2;
        // Use cos and sin to create waves
        uv.x += cos(uv.y * 13.0) * (0.15 * pow(sin(uv.y + speed), 3.0));
        uv.y += sin(uv.x * 11.0) * (0.13 * pow(sin(uv.x + speed), 2.0));
        uv.y *= uv.x;
        // Use modulo operator to create lines
        vec3 color = vec3(mod(ceil(uv.y * 23.0), 2.0));
        gl_FragColor = vec4(color, 1.0);
    }

|]
