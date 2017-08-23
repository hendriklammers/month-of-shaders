module Shader.Day23 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform vec2 u_mouse;
    uniform float u_time;

    const float PI = 3.141592653589793;
    const float HALF_PI = 1.5707963267948966;

    // Pseudo random number generator
    float random (in vec2 st) {
        return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
    }

    float sineOut(float t) {
        return sin(t * HALF_PI);
    }

    void main() {
        vec2 p = gl_FragCoord.xy / min(u_resolution.x, u_resolution.y);
        float speed = u_time * 0.8;
        float grid = 10.0;
        vec2 uv = fract(p * grid);
        uv = abs(uv * 2.0 - 1.0);
        vec2 index = floor(p * grid);
        float t = floor(speed) + 1.0;
        // Glowing circle
        float circ = 1.0 / length(uv * 0.5) * 0.05;
        float r1 = random(index + t);
        float r2 = random(index + t + 1.0);
        // Create smooth transition between two random numbers
        float tween = mix(r1, r2, (fract(speed)));
        gl_FragColor = vec4(vec3(circ * tween), 1.0);
    }

|]
