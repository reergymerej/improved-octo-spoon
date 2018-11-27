module Main exposing (main)

import Browser
import Browser.Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string)


type Route
    = Topic String
    | Blog Int
    | User String
    | Comment String Int



-- Parser is a type from Url.Parser.
-- type Parser a b
-- It takes a thing and returns a different thing.
-- string, int, and s are parsers.


routeParser : Parser (Route -> a) a
routeParser =
    -- Tries a bunch of parsers.
    -- oneOf : List (Parser a b) -> Parser a b
    oneOf
        [ map Topic (s "topic" </> string)
        , map Blog (s "blog" </> int)
        , map User (s "user" </> string)
        , map Comment (s "user" </> string </> s "comment" </> int)
        ]


type alias Model =
    { key : Browser.Navigation.Key
    , message : String
    , route : Maybe Route
    }


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key
      , message = ""
      , route = Nothing
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
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model, Browser.Navigation.load url )

        UrlChanged url ->
            ( { model | message = Url.toString url }, Cmd.none )


viewLink : String -> Html Msg
viewLink path =
    div []
        [ a [ href path ] [ text path ]
        ]


viewRoute : Maybe Route -> Html Msg
viewRoute route =
    case route of
        Nothing ->
            div [] [ text "route?" ]

        Just theRoute ->
            case theRoute of
                Topic val ->
                    div [] [ text ("topic: " ++ val) ]

                Blog val ->
                    div [] [ text ("blog: " ++ String.fromInt val) ]

                User val ->
                    div [] [ text ("user: " ++ val) ]

                Comment user comment ->
                    div [] [ text ("comment: " ++ user ++ String.fromInt comment) ]


view : Model -> Browser.Document Msg
view model =
    { title = model.message
    , body =
        [ div [] [ text model.message ]
        , viewRoute model.route
        , viewLink "#home"
        , viewLink "#home/gingo"
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
