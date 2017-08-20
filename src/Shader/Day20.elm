module Shader.Day20 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    const float PI = 3.14159265359;
    const float HALF_PI = 1.5707963267948966;

    void main() {
        vec2 uv = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
        float t = -u_time * 11.7;

        float y = sin(uv.x * 25.0 + t);
        y *= 0.4 * pow(max(0.0, 1.0 - abs(uv.x * 0.7)), 3.0);

        float c = 1.0 / abs(uv.y + y) * 0.02;
        float r = c * 0.7;
        float g = c * 0.4;
        float b = c * 0.8;
        gl_FragColor = vec4(r, g, b, 1.0);
    }

|]
