module Shader.Day24 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform vec2 u_mouse;
    uniform float u_time;

    const vec3 pink = vec3(0.843, 0.0, 0.376);
    const vec3 yellow = vec3(1.0, 0.773, 0.039);

    vec2 mapUV(vec2 coord) {
        return (2.0 * coord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
    }

    mat2 rotate(float theta) {
        return mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
    }

    float dfSphere(vec3 p, float size) {
        return length(p) - size;
    }

    float dfDisplace(vec3 p) {
        return 0.5 * (abs(sin(u_time)) * 0.7 + 0.3) * sin(8.0 * p.x - u_time) * sin(8.0 * p.y - u_time) * sin(8.0 * p.z);
    }

    float distanceField(vec3 p) {
        float df1 = dfSphere(p, 0.5);
        float df2 = dfDisplace(p);
        return df1 + df2;
    }


    float trace(vec3 ro, vec3 rd) {
        vec2 mouse = mapUV(u_mouse);
        float t = 0.0;
        for (int i = 0; i < 16; i++) {
            vec3 p = ro + rd * t;
            p.xz *= rotate(mouse.x * 0.2);
            p.yz *= rotate(mouse.y * 0.2);
            p.xy *= rotate(-u_time * 0.1);
            float d = distanceField(p);
            t += d * 0.45;
            if (d < 0.3) break;
        }
        return t;
    }

    void main() {
        vec2 uv = mapUV(gl_FragCoord.xy);

        // Vignette background with yellow burst in center
        vec3 bg = mix(yellow, pink, clamp(length(uv * 0.85), 0.3, 1.0));
        bg = mix(bg, pink * 0.8, (0.3 * pow(length(uv), 3.0)));

        // ray origin
        vec3 ro = vec3(0.0, 0.0, -2.0);
        // ray direction
        vec3 rd = normalize(vec3(uv, 1.0));
        float t = trace(ro, rd);
        vec3 color = mix(bg, yellow, 1.0 / t);
        gl_FragColor = vec4(color, 1.0);
    }

|]
