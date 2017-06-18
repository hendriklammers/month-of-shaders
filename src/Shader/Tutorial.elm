module Shader.Tutorial exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    void main () {
        // Normalize position
        vec2 pos = gl_FragCoord.xy / u_resolution;

        float red = abs(cos(u_time * 0.2));
        float blue = 0.3 + abs(sin(u_time * 0.5) - 0.3);
        float green = 0.0;

        if (pos.x > 0.5) {
            green = 1.0;
            red = clamp(red, 0.1, 0.9);
        }

        vec3 color = vec3(red, green, blue);

        if (pos.x < 0.1 && pos.y < 0.1) {
            color = vec3(1.0, 1.0, 1.0);
        }

        if (pos.x > 0.49 && pos.x < 0.51 && pos.y > 0.49 && pos.y < 0.51) {
            color = vec3(0.0, 0.0, 0.0);
        }

        gl_FragColor = vec4(color, 1.0);
    }

|]
