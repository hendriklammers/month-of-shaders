module Shader.Day28 exposing (..)

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
        vec2 mouse = mapUV(u_mouse.xy);
        float l = length(uv);

        uv -= clamp(mouse, -1.0, 1.0) * 0.2 * l;
        uv *= rotate(u_time * 0.3);

        // Create tunnel
        float x = atan(uv.y, uv.x) / PI;
        float y = 0.5 / length(uv) + u_time * 0.3;

        // Create checkerboard pattern
        vec2 s = sin(vec2(x, y) * PI * 10.0);
        float v = step(s.x * s.y, 0.0);
        // Lighten center
        v *= 1.0 - smoothstep(1.5, 0.07, length(uv));

        vec3 light = vec3(0.925,0.988,0.553);
        vec3 dark = vec3(0.850,0.100,0.323);
        vec3 color = mix(light, dark, v);
        color = mix(color, dark * 0.3, (0.25 * pow(l, 2.0)));
        gl_FragColor = vec4(color, 1.0);
    }

|]
