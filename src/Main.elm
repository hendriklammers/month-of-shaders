module Main exposing (..)

import AnimationFrame
import Html exposing (..)
import Html.Attributes
    exposing
        ( id
        , width
        , height
        , style
        , href
        , class
        , classList
        )
import Html.Events exposing (onWithOptions, onClick)
import Json.Decode as Decode
import Math.Vector2 exposing (vec2)
import Shader.Vertex exposing (vertexShader)
import Task
import Types exposing (..)
import WebGL exposing (entity, toHtml)
import Window exposing (Size)
import Keyboard
import Mouse exposing (Position)
import Shaders exposing (shaders)
import List.Extra exposing (getAt, elemIndex)
import Mesh exposing (mesh)


-- Model


initialModel : Model
initialModel =
    { size = Size 0 0
    , time = 0
    , activeShader = List.head shaders
    , shaders = shaders
    , paused = True
    , mouse = Position 0 0
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Task.perform WindowResize Window.size )



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        WindowResize size ->
            ( { model | size = size }, Cmd.none )

        TimeUpdate time ->
            ( { model | time = model.time + time }, Cmd.none )

        ChangeShader index ->
            setActiveShader index model ! []

        KeyPress keycode ->
            handleKeyPresses keycode model

        MouseMove position ->
            ( { model | mouse = position }, Cmd.none )

        PauseClick ->
            ( { model | paused = not model.paused }, Cmd.none )


handleKeyPresses : Int -> Model -> ( Model, Cmd Msg )
handleKeyPresses keycode model =
    let
        updatedModel =
            case keycode of
                -- spacebar
                32 ->
                    { model | paused = not model.paused }

                -- left arrow
                37 ->
                    jumpToShader -1 model

                -- right arrow
                39 ->
                    jumpToShader 1 model

                -- up arrow
                38 ->
                    jumpToShader -5 model

                -- down arrow
                40 ->
                    jumpToShader 5 model

                -- nextShader model
                _ ->
                    model
    in
        ( updatedModel, Cmd.none )


jumpToShader : Int -> Model -> Model
jumpToShader position model =
    case model.activeShader of
        Just shader ->
            case elemIndex shader model.shaders of
                Just index ->
                    setActiveShader (index + position) model

                Nothing ->
                    model

        Nothing ->
            model


setActiveShader : Int -> Model -> Model
setActiveShader index model =
    let
        i =
            if index < 0 then
                0
            else if index >= List.length model.shaders then
                List.length model.shaders - 1
            else
                index

        active =
            getAt i model.shaders
    in
        { model | activeShader = active, time = 0 }



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Window.resizes WindowResize
        , Keyboard.ups (\keycode -> KeyPress keycode)
        , pausableSubscriptions model.paused
        ]


pausableSubscriptions : Bool -> Sub Msg
pausableSubscriptions paused =
    if paused then
        Sub.none
    else
        Sub.batch
            [ AnimationFrame.diffs TimeUpdate
            , Mouse.moves MouseMove
            ]



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ id "container" ]
        [ viewCanvas model
        , viewNavigation model
        , viewPause model.paused
        ]


viewPause : Bool -> Html Msg
viewPause paused =
    if paused then
        div
            [ class "pause" ]
            [ span
                [ onClick PauseClick ]
                [ text "Paused (Press SPACE to resume)" ]
            ]
    else
        text ""


isShaderActive : Maybe ShaderObject -> ShaderObject -> Bool
isShaderActive active current =
    case active of
        Just shader ->
            shader.id == current.id

        Nothing ->
            False


viewLink : Maybe ShaderObject -> Int -> ShaderObject -> Html Msg
viewLink active index shader =
    let
        isActive =
            isShaderActive active shader
    in
        li [ class "navigation__item" ]
            [ viewTooltip shader.title
            , a
                [ href "#"
                , onLinkClick (not isActive) (ChangeShader index)
                , classList
                    [ ( "navigation__link", True )
                    , ( "navigation__link--active"
                      , isActive
                      )
                    ]
                ]
                [ text (toString <| index + 1) ]
            ]


viewTooltip : String -> Html Msg
viewTooltip str =
    div
        [ class "tooltip" ]
        [ span [] [ text str ] ]


viewNavigation : Model -> Html Msg
viewNavigation { shaders, activeShader } =
    nav [ class "navigation" ]
        [ ul [ class "navigation__list" ]
            (List.indexedMap (viewLink activeShader) shaders)
        ]


onLinkClick : Bool -> Msg -> Attribute Msg
onLinkClick enabled msg =
    let
        decoder =
            if enabled then
                Decode.succeed msg
            else
                Decode.succeed NoOp
    in
        onWithOptions
            "click"
            { stopPropagation = True
            , preventDefault = True
            }
            decoder


viewCanvas : Model -> Html Msg
viewCanvas { size, time, activeShader, mouse } =
    case activeShader of
        Nothing ->
            text "No shader available"

        Just shader ->
            toHtml
                [ id "canvas"
                , width size.width
                , height size.height
                , style (canvasStyle size.width size.height)
                ]
                [ entity
                    vertexShader
                    shader.fragment
                    mesh
                    { u_resolution =
                        vec2
                            (toFloat size.width)
                            (toFloat size.height)
                    , u_time = time / 1000
                    , u_mouse =
                        vec2
                            (toFloat mouse.x)
                            -- Inverting mouse.y so it matches gl_FragCoord.y
                            (toFloat <| size.height - mouse.y)
                    }
                ]


canvasStyle : Int -> Int -> List ( String, String )
canvasStyle width height =
    [ ( "display", "block" )
    , ( "width", toString width ++ "px" )
    , ( "height", toString height ++ "px" )
    , ( "background", "#000" )
    ]



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
