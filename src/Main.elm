module Scratch exposing (main)

import Html exposing (..)
import Html.App as App
import Task
import HttpBuilder exposing (..)
-- import Http

main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL

type Msg
  = Noop
  | GetLocationSuccess String
  | GetLocationFail

type alias Model = { json : Maybe String }

init : (Model, Cmd Msg)
init = ({ json = Nothing }, getLocations)

-- VIEW

view : Model -> Html Msg
view model =
  case model.json of
    Nothing ->
      div [] [
        text "No JSON yet...."
      ]

    Just json ->
      div [] [
        text "We got some JSON: ",
        text json
      ]

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Noop ->
      (model, Cmd.none)
    GetLocationFail ->
      ({model | json = Nothing}, Cmd.none)
    GetLocationSuccess string ->
      ({model | json = Just string}, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

getLocations : Cmd Msg
getLocations =
  let
    url =
      "http://localhost:4567/locations"
    getJsonError = \_ -> GetLocationFail
    getJsonSuccess = \response -> GetLocationSuccess response.data
    task = get url
      |> send stringReader stringReader
  in
    -- Task.perform getJsonError getJsonSuccess (Http.getString url)
    Task.perform getJsonError getJsonSuccess task
