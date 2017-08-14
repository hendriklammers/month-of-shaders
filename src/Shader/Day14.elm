module Shader.Day14 exposing (..)

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

    mat2 rotate(float theta) {
        return mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
    }

    //  www.iquilezles.org/www/articles/functions/functions.htm
    float impulse(float k, float x){
        float h = k * x;
        return h * exp(1.0 - h);
    }

    void main () {
        vec2 uv = (2.0 * gl_FragCoord.xy - u_resolution)
            / min(u_resolution.x, u_resolution.y);

        // normalize time
        float t = abs(fract(u_time * 0.8) * 2.0 - 1.0);
        t = pow(t, 4.0);

        // Distort circle based on time
        float x = 2.0 * uv.x + (t * sin(u_time * 2.4 + uv.y * 6.68) * 0.1);
        float y = 2.0 * uv.y + (t * sin(u_time * 1.1 + uv.x * 8.31) * 0.1);
        float d = clamp(1.0 - length(vec2(x, y)), 0.0, 1.0);

        vec3 blue = vec3(0.278, 0.38, 0.604);
        vec3 orange = vec3(0.82, 0.514, 0.224);
        vec3 yellow = vec3(0.929, 0.847, 0.357);
        vec3 grey = vec3(0.294, 0.247, 0.255);

        // Combine colors to create circular gradient
        vec3 color = mix(grey, blue, impulse(12.0, d));
        color = mix(color, orange,  pow(d, 2.0));
        color = mix(color, yellow, pow(d, 4.0));

        gl_FragColor = vec4(color, 1.0);
    }

|]
