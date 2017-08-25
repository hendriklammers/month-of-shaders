module Shader.Day25 exposing (..)

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
        p = fract(p * 0.5) * 2.0 - 1.0;
        float df = dfSphere(p, 0.75);
        return df;
    }

    vec3 calculateNormal(vec3 pt) {
        vec2 eps = vec2(1.0, -1.0) * 0.005;
        return normalize(
            eps.xyy * distanceField(pt + eps.xyy) +
            eps.yyx * distanceField(pt + eps.yyx) +
            eps.yxy * distanceField(pt + eps.yxy) +
            eps.xxx * distanceField(pt + eps.xxx));
    }

    float intersect(vec3 ro, vec3 rd) {
        float t = 0.0;
        for (int i = 0; i < 32; i++) {
            vec3 p = ro + rd * t;
            float d = distanceField(p);
            t += d * 0.8;
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
        rd.xz *= rotate(u_time * 0.5);
        rd.yz *= rotate(-u_time * 0.5);

        float id = intersect(ro, rd);

        // Normal color mapping
        vec3 n = calculateNormal(ro + rd * id);
        vec3 color = vec3(n.x, n.y, 1.0);

        float fog = 1.0 / (1.0 + pow(id, 2.0) * 0.3);
        color = mix(vec3(0.5, 0.3, 0.8), color, fog);

        gl_FragColor = vec4(color, 1.0);
    }

|]
