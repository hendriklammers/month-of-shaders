module Shader.Day22 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform vec2 u_mouse;
    uniform float u_time;

    const vec3 c1 = vec3(0.345, 0.129, 0.831);
    const vec3 c2 = vec3(0.824, 0.984, 0.471);

    vec2 mapUV(vec2 coord) {
        return (2.0 * coord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
    }

    mat2 rotate(float theta) {
        return mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
    }

    float dfSphere(vec3 p, float size) {
        return length(p) - size;
    }

    float dfBox(vec3 p, vec3 b) {
        return length(max(abs(p) - b, 0.0));
    }

    float distanceField(vec3 p) {
        // Create multiple instances and rotate
        p = fract(p) * 2.0 - 1.0;
        p.xz *= rotate(u_time);
        p.yz *= rotate(u_time);

        float df1 = dfSphere(p, 0.45);
        float df2 = dfBox(p, vec3(0.4));
        // Substract sphere from box
        return max(-df1, df2);
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
        vec2 mouse = mapUV(u_mouse);

        // ray origin
        vec3 ro = vec3(0.0, 0.0, u_time);
        // ray direction
        vec3 rd = normalize(vec3(uv, 1.0));
        rd.xz *= rotate(-mouse.x * 0.2);
        rd.yz *= rotate(-mouse.y * 0.2);

        float t = trace(ro, rd);
        float fog = 1.0 / (1.0 + pow(t, 3.0) * 0.3);
        vec3 color = mix(c1, c2, fog);

        gl_FragColor = vec4(color, 1.0);
    }

|]
