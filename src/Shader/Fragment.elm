module Shader.Fragment exposing (..)

import WebGL exposing (Shader)
import Types exposing (..)


fragmentShader : Shader {} Uniforms Varying
fragmentShader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;
    varying vec2 v_fragCoord;

    void main () {
        gl_FragColor = vec4(0.2, 0.0, 0.7, 1.0);
    }

|]
