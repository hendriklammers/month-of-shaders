module Shader.Day19 exposing (..)

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

    mat2 rotate(float theta) {
        return mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
    }

    float sineOut(float t) {
        return sin(t * HALF_PI);
    }

    void main() {
        vec2 uv = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
        // grid
        float g = 10.0;
        vec2 p = 2.0 * fract(uv * g) - 1.0;
        // index of block on the grid
        vec2 i = floor(uv * g);
        // rotation per second
        float r = PI * 0.25;
        float speed = u_time * 0.8;
        float t = sineOut(fract(speed)) * r;
        p *= rotate(floor(speed) * r + t + (i.x + i.y) * PI);
        float s = smoothstep(0.0, 0.02, p.x);
        vec3 col = vec3(s);
        gl_FragColor = vec4(col, 1.0);
    }

|]
