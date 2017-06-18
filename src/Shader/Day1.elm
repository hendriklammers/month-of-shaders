module Shader.Day1 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    void main () {
        vec2 st = gl_FragCoord.xy/u_resolution;
        gl_FragColor = vec4(st.x,st.y,0.0,1.0);
    }

|]
