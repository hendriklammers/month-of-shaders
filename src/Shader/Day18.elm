module Shader.Day18 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    vec2 mapUV(vec2 coord) {
        return (2.0 * coord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
    }

    void main () {
        vec2 uv = mapUV(gl_FragCoord.xy);
        float t = abs(fract(u_time * 0.7 + sin(uv.y * 26.0) * 0.1) * 0.2) * 2.0 - 1.0);
        vec2 p = vec2(uv.x, uv.y * 1.2 - abs(uv.x) * (1.15 - abs(uv.x)));
        p *= 1.2 - pow(t, 4.0) * 0.2;
        float c = 1.0 / abs(length(vec2(0.3)) - length(p)) * 0.02;
        vec3 color = vec3(c - 0.1, c * 0.3, c * 0.4);
        gl_FragColor = vec4(color,1.0);
    }

|]
