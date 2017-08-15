module Shader.Day15 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    float polygon(vec2 uv, float size, float sides) {
        float b = 6.28319 / sides;
        float a = atan(uv.x, uv.y);
        float f = cos(floor(0.5 + a / b) * b - a) * length(uv);
        return smoothstep(size, size - 0.005, f);
    }

    vec2 mapUV(vec2 coord) {
        return (2.0 * coord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
    }

    mat2 rotate(float theta) {
        return mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
    }

    void main () {
        vec2 uv = mapUV(gl_FragCoord.xy);

        vec3 colors[5];
        colors[0] = vec3(0.008, 0.024, 0.027);
        colors[1] = vec3(1.0, 0.776, 0.102);
        colors[2] = vec3(0.886, 0.004, 0.404);
        colors[3] = vec3(0.012, 0.58, 0.906);
        colors[4] = vec3(1.0, 0.804, 0.867);

        vec3 color = colors[0];

        for (float i = 1.0; i <= 5.0; i++) {
            float sides = 8.0 - i;
            float size = 0.5 - i * 0.1;
            mat2 r = rotate(u_time + 1.0 / sides * sin(u_time * sides));
            vec2 p = uv * r;
            float poly = polygon(p, size, sides);
            color = mix(color, colors[int(i)], poly);
        }

        gl_FragColor = vec4(color,1.0);
    }

|]
