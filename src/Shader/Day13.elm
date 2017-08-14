module Shader.Day13 exposing (..)

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

    mat2 rotate(float theta) {
        return mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
    }

    void main () {
        vec2 uv = mapUV(gl_FragCoord.xy);
        vec2 p = abs(uv);
        // Split screen horizizontally in 20-40 parts
        float i = fract(p.x * (40.0));
        // Rotate coordinates from center
        p -= 0.5;
        p *= rotate(i + u_time * 0.5);

        float r = p.x / p.y;
        float g = p.y * p.x * abs(sin(u_time));
        float b = abs(sin(p.x + u_time));
        vec3 color = vec3(r, g, b);

        gl_FragColor = vec4(color,1.0);
    }

|]
