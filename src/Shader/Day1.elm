module Shader.Day1 exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


shader : Shader {} Uniforms Varying
shader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;
    varying vec2 v_fragCoord;

    void main () {
        gl_FragColor = vec4(1.0, 0.0, 0.2, 1.0);
    }

|]
