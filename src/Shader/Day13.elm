module Shader.Day13 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform vec2 u_mouse;
    uniform float u_time;

    vec2 mapUV(vec2 coord) {
        return (2.0 * coord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
    }

    mat2 rotate(float angle) {
        return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    }

    void main () {
        vec2 uv = mapUV(gl_FragCoord.xy);
        vec2 p = abs(uv);
        // Mouse: 1.0 - 0.0 - 1.0
        vec2 m = abs(mapUV(u_mouse.xy));
        // Split screen horizizontally in 20-40 parts
        float i = fract(p.x * (20.0 + m.x * 20.0));
        // Rotate coordinates from center
        p -= 0.5;
        p *= rotate(i + u_time * 0.5);

        vec3 color = vec3(p.x / p.y, p.y * p.x * abs(sin(u_time)), abs(sin(p.x + u_time)));

        gl_FragColor = vec4(color,1.0);
    }

|]
