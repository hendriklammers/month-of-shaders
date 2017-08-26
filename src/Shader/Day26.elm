module Shader.Day26 exposing (..)

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
        mat2 r = rotate(u_time * 2.0);
        vec3 p1 = vec3(p.x + sin(u_time) * 2.0, p.y, p.z + cos(u_time) * 1.5);
        p1.xz *= r;
        p1.xy *= r;
        float b1 = dfBox(p1, vec3(0.2));

        vec3 p2 = vec3(p.x + sin(u_time + PI) * 2.0, p.y, p.z + cos(u_time + PI) * 1.5);
        p2.xz *= r;
        p2.xy *= r;
        float b2 = dfBox(p2, vec3(0.2));

        // Sphere at center of screen
        float s = dfSphere(p, 0.6);

        return min(min(b1, b2), s);
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
        float t = 1.0;
        for (int i = 0; i < 32; i++) {
            vec3 p = ro + rd * t;
            float d = distanceField(p);
            t += d * 0.8;
            if (d < 0.01) break;
        }
        return t;
    }

    void main() {
        vec2 uv = mapUV(gl_FragCoord.xy);
        vec2 mouse = mapUV(u_mouse);

        // ray origin
        vec3 ro = vec3(0.0, 0.0, -3.0);
        // ray direction
        vec3 rd = normalize(vec3(uv, 1.0));

        float id = intersect(ro, rd);

        vec3 color = vec3(0.5, 0.3, 0.7);

        if (id < 5.0) {
            // Normal color mapping
            vec3 n = calculateNormal(ro + rd * id);
            color = vec3(n.x * 0.5 + 0.5, n.y * -0.5 + 0.5, 1.0);
        }

        gl_FragColor = vec4(color, 1.0);
    }

|]
