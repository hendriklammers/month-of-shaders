module Shader.Day31 exposing (..)

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

    void main() {
        vec2 uv = mapUV(gl_FragCoord.xy);
        float time = u_time * 1.3;
        uv *= 2.8;
        float v = sin((uv.x + time));
        v += sin((uv.y + time) / 2.0);
        v += sin((uv.x + uv.y + time) / 2.0);
        uv -= 3.0 * vec2(sin(time / 5.0), cos(time / 2.5));
        v += sin(sqrt(uv.x * uv.x + uv.y * uv.y + 1.0) + time);
        v += sin(uv.x + uv.y + time);
        float r = cos(PI * v) * 0.5 + 0.5;
        float g = sin(PI * v) * 0.5 + 0.5;
        float b = 1.0 - cos(PI * v) * 0.3;
        vec3 color = vec3(r, g, b);
        gl_FragColor = vec4(color, 1.0);
    }

|]
