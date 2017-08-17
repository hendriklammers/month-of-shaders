module Shader.Day16 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform vec2 u_mouse;
    uniform float u_time;

    vec2 mapUV(vec2 coord) {
        return (2.0 * coord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
    }

    void main () {
        vec2 uv = mapUV(gl_FragCoord.xy);
        vec2 mouse = mapUV(u_mouse.xy);
        // Subtle mouse movement based on mouse distance from center
        uv -= mouse * 0.08 * (1.0 - length(uv));
        float dist = length(uv);
        float angle = atan(uv.y, uv.x);
        float speed = u_time * 3.25;
        // Create circles that rotate CCW based on time
        float pct = sin(dist * (45.0 - dist * 10.0) + angle - speed);
        // Solid shapes instead of blurred transitions
        pct = smoothstep(0.0, 0.05, pct);
        vec3 pink = vec3(0.949, 0.153, 0.714);
        vec3 black = vec3(0.0);
        vec3 color = mix(black, pink, pct);
        color = mix(color, black, smoothstep(0.2, 1.0, length(uv * 0.7)));
        gl_FragColor = vec4(color,1.0);
    }

|]
