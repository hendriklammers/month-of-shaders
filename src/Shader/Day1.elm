module Shader.Day1 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms {}
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform vec2 u_mouse;
    uniform float u_time;

    void main () {
        vec2 coord = gl_FragCoord.xy / u_resolution;
        vec2 mouse = u_mouse.xy / u_resolution;

        vec3 color = vec3(0.0);

        if (coord.x <= 0.25) {
            float amount = coord.x / 0.25;
            color.r = amount - (coord.y);
        }
        else if (coord.x > 0.25 && coord.x <= 0.5) {
            float amount = ((coord.x - 0.25) / 0.25);
            color.r = 1.0 - amount;
            color.g = amount;
        }
        else if (coord.x > 0.5 && coord.x <= 0.75) {
            float amount = ((coord.x - 0.5) / 0.25);
            color.g = 1.0 - amount;
            color.b = amount;
        }
        else if (coord.x > 0.75) {
            float amount = ((coord.x - 0.75) / 0.25);
            color.b = 1.0 - amount;
        }

        gl_FragColor = vec4(color, 1.0);
    }

|]
