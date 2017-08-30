module Shader.Day30 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform vec2 u_mouse;
    uniform float u_time;

    const vec3 pink = vec3(0.953, 0.027, 0.851);
    const vec3 rose = vec3(0.929, 0.604, 0.894);
    const vec3 yellow = vec3(0.863, 0.953, 0.055);
    const vec3 black = vec3(0.027, 0.027, 0.027);
    const vec3 blue = vec3(0.086, 0.878, 0.937);

    mat2 rotate(float theta) {
        return mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
    }

    void main() {
        vec2 uv = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
        uv *= 5.0;
        // Offset
        uv.x += step(1.0, mod(uv.y, 2.0)) * 0.5;
        vec2 id = floor(uv);
        vec2 p = fract(uv);
        // Use uv coords for each section
        p = p * 2.0 - 1.0;
        p *= rotate((id.x + id.y) + u_time * (0.5 + sin(id.x + id.y) * 0.3));
        float l = length(p);
        float a = atan(p.y, p.x);
        float r = 0.8 + 0.2 * abs(cos(a * 6.0));
        float c = smoothstep(r, r - 0.05, l);
        float r2 = 0.55 + 0.3 * abs(cos(a * 6.0));
        float c2 = smoothstep(r2, r2 - 0.05, l);
        vec3 color = rose;
        color = mix(color, blue, c);
        color = mix(color, pink, c2);
        float r3 = 0.3;
        color = mix(color, yellow, smoothstep(r3, r3 - 0.05, l));
        gl_FragColor = vec4(color, 1.0);
    }

|]
