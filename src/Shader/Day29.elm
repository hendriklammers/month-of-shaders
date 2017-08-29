module Shader.Day29 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms {}
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

    mat2 rotate(float theta) {
        return mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
    }

    void main () {
        vec2 uv = mapUV(gl_FragCoord.xy);
        float l = length(uv);

        uv *= rotate(-u_time * 0.2);

        // Create tunnel
        float x = atan(uv.y, uv.x) / PI;
        float y = 0.5 / length(uv) + u_time * 0.1;

        vec2 s = sin(vec2(x, y) * PI * 12.0);
        float v = step(s.x * s.y, 0.0);
        v = pow(1.0 / length(s * 0.3) * 0.1, 3.0);

        v *= 1.0 - smoothstep(1.5, 0.2, length(uv));

        vec3 light = vec3(0.443, 0.918, 0.859);
        vec3 dark = vec3(0.075, 0.0, 0.157);
        vec3 color = mix(dark, light, v);
        gl_FragColor = vec4(color, 1.0);
    }

|]
