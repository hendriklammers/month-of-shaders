module Shader.Day12 exposing (..)

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
        float t = u_time * 0.8;
        float r = abs(sin(uv.x * uv.y * 5.788 + t * 0.3));
        float g = abs(sin(fract(uv.x * uv.y * 13.960 + t * 0.9)));
        float b = abs(sin(uv.y * uv.x * 7.160 + t * 1.5));
        vec3 color = vec3(r * g * b);
        gl_FragColor = vec4(color, 1.0);
    }

|]
