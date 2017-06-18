module Shader.Day2 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;

    void main () {
        gl_FragColor = vec4(0.0, 1.0, 0.2, 1.0);
    }

|]
