module Shader.Day27 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms {}
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    const vec3 col1 = vec3(0.443, 0.918, 0.859);
    const vec3 col2 = vec3(0.243, 0.039, 0.373);

    float random (in vec2 st) {
        return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
    }

    void main () {
        vec2 uv = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
        // Split coordinates in 10 parts on both axis
        uv *= 10.0;
        vec2 uvi = floor(uv);
        vec2 uvf = fract(uv);

        float speed = u_time * 1.5;
        float ti = floor(speed);
        float tf = fract(speed);
        // linear interpolation between 2 random values
        float m = mix(random(vec2(ti - 1.0) + uvi), random(vec2(ti) + uvi), tf);
        // Using smoothstep to create gradients
        vec3 color = mix(col1, col2, smoothstep(min(m, -0.5), m * 1.4, uvf.y)) * 1.1;
        gl_FragColor = vec4(color, 1.0);
    }

|]
