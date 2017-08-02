{--| Inspired by: https://upload.wikimedia.org/wikipedia/commons/6/62/Composition_with_Color_Fields_by_Piet_Mondrian.jpg --}


module Shader.Day2 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    // Creates a rectangle shape
    // offset is used to add some variation in the animations
    float rect(vec2 uv, vec2 pos, vec2 size, float offset) {
        // Animate position
        vec2 p = pos + sin(u_time * 5.0 + offset) * 0.03;

        // bottom-left (Everything on the right and above will be 1.0)
        // multiplying by 0.5 so origin of the rect will be centered
        vec2 bl = step(p - size * 0.5, uv);

        // top-right
        vec2 tr = p + size * 0.5;
        // inverting coordinates (Everything on the left and below will be 1.0)
        tr = step(tr *= -1.0, 0.0 - uv);

        // Using multiply here acts as AND operator
        return bl.x * bl.y * tr.x * tr.y;
    }

    void main () {
        // Use cartesian coordinate system
        // Dividing by y resolution so vertical coords are between -1.0 and 1.0
        vec2 uv = 2.0 * vec2(gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;

        vec3 bg = vec3(0.941, 0.886, 0.850);
        vec3 yellow = vec3(0.937, 0.796, 0.325);
        vec3 blue = vec3(0.474, 0.615, 0.709);
        vec3 pink = vec3(0.854, 0.592, 0.627);

        vec3 color = bg;

        // Using mix to blend previous color with another color
        // based on the output of the rect function
        color = mix(color, yellow, rect(uv, vec2(-0.3, 0.3), vec2(0.25, 0.25), 0.0));
        color = mix(color, blue, rect(uv, vec2(-0.3, 0.0), vec2(0.25, 0.25), 0.5));
        color = mix(color, pink, rect(uv, vec2(-0.3, -0.3), vec2(0.25, 0.25), 1.5));

        color = mix(color, blue, rect(uv, vec2(0.0, 0.3), vec2(0.25, 0.25), 3.0));
        color = mix(color, pink, rect(uv, vec2(0.0, 0.0), vec2(0.25, 0.25), 2.5));
        color = mix(color, yellow, rect(uv, vec2(0.0, -0.3), vec2(0.25, 0.25), 2.0));

        color = mix(color, pink, rect(uv, vec2(0.3, 0.3), vec2(0.25, 0.25), 3.5));
        color = mix(color, yellow, rect(uv, vec2(0.3, 0.0), vec2(0.25, 0.25), 4.0));
        color = mix(color, blue, rect(uv, vec2(0.3, -0.3), vec2(0.25, 0.25), 4.5));

        gl_FragColor = vec4(color, 1.0);
    }

|]
