-- Reference tutorial: https://www.youtube.com/watch?v=yxNnRSefK94


module Shader.Day21 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
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

    // Sphere distance field
    // http://iquilezles.org/www/articles/distfunctions/distfunctions.htm
    float dfSphere(vec3 p, float size) {
        return length(p) - size;
    }

    // Combined distance field
    float distanceField(vec3 p) {
        float t = u_time * 0.5;
        float t2 = u_time * 4.0;
        float df1 = dfSphere(p + vec3(sin(t), cos(t), sin(t2)), 0.2);
        float df2 = dfSphere(p + vec3(sin(PI * 0.5 + t), cos(PI * 0.5 + t), sin(PI * 0.25 + t2)), 0.2);
        float df3 = dfSphere(p + vec3(sin(PI + t), cos(PI + t), sin(PI * 0.5 + t2)), 0.2);
        float df4 = dfSphere(p + vec3(sin(PI * 1.5 + t), cos(PI * 1.5 + t), sin(PI * 0.75 + t2)), 0.2);
        return min(df1, min(df2, min(df3, df4)));
    }


    float trace(vec3 ro, vec3 rd) {
        float t = 0.0;
        for (int i = 0; i < 32; i++) {
            vec3 p = ro + rd * t;
            float d = distanceField(p);
            t += d * 0.5;
        }
        return t;
    }

    void main() {
        vec2 uv = mapUV(gl_FragCoord.xy);

        // ray origin
        vec3 ro = vec3(0.0, 0.0, -3.0);
        // ray direction
        vec3 rd = normalize(vec3(uv, 1.0));

        float t = trace(ro, rd);
        float fog = 1.0 / (1.0 + pow(t, 2.0) * 0.2);

        vec3 color = vec3(fog);
        gl_FragColor = vec4(color, 1.0);
    }

|]
