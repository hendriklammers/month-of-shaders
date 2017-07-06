module Shader.Tutorial.Plasma exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;
    uniform vec2 u_mouse;

    void main () {
        float pi = 3.14159265359;
        float twopi = 6.28318530718;

        vec2 r = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
        vec2 p = vec2(gl_FragCoord.xy / u_resolution.xy);
        float xMax = u_resolution.x / u_resolution.y;
        r = r * 8.0;

        float v1 = sin(r.x + u_time);
        float v2 = sin(r.y + u_time);
        float v3 = sin(r.x + r.y + u_time);
        float v4 = sin(length(r) + 1.7 * u_time);
        float v = v1 + v2 + v3 + v4;
        vec3 ret;

        if (p.x < 1.0 / 10.0) {
            // vertical waves
            ret = vec3(v1);
        } else if (p.x < 2.0 / 10.0) {
            // Horizontal waves
            ret = vec3(v2);
        } else if (p.x < 3.0 / 10.0) {
            // Diagonal waves
            ret = vec3(v3);
        } else if (p.x < 4.0 / 10.0) {
            // Circular waves
            ret = vec3(v4);
        } else if (p.x < 5.0 / 10.0) {
            // Sum of all waves
            ret = vec3(v);
        } else if (p.x < 6.0 / 10.0) {
            ret = vec3(sin(2.0 * v));
        } else {
            // Mix colors
            v *= 1.0;
            ret = vec3(sin(v), sin(v + 0.5 * pi), sin(v + 1.0 * pi));
        }

        ret = 0.5 + 0.5 * ret;

        vec3 pixel = ret;
        gl_FragColor = vec4(pixel, 1.0);
    }

|]
