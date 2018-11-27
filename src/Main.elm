module Main exposing (main)

import Browser
import Browser.Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Url


type alias Model =
    { num : Int
    , message : String
    }


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags key url =
    ( { num = 99
      , message = ""
      }
    , Cmd.none
    )


onUrlChange : Url.Url -> Msg
onUrlChange url =
    UrlChanged url



{-
   type UrlRequest
     = Internal Url.Url
     | External String
-}


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest req =
    LinkClicked req


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked req ->
            case req of
                Browser.Internal url ->
                    ( { model
                        | message = "internal"
                      }
                    , Cmd.none
                    )

                Browser.External url ->
                    ( { model
                        | message = url
                      }
                    , Cmd.none
                    )

        UrlChanged url ->
            ( model, Cmd.none )


viewLink : String -> Html Msg
viewLink path =
    div []
        [ a [ href path ] [ text path ]
        ]


view : Model -> Browser.Document Msg
view model =
    { title = "Hello!"
    , body =
        [ div [] [ text model.message ]
        , div [] [ text (String.fromInt model.num) ]
        , viewLink "/home"
        , viewLink "/home/gingo"
        , viewLink "https://google.com"
        ]
    }


main =
    Browser.application
        { init = init
        , onUrlChange = onUrlChange
        , onUrlRequest = onUrlRequest
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
