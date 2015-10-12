module Main where

import Html exposing (Html, Attribute, text, toElement, div, input, span, button)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue, onClick)

import String

import Debug exposing (log)

type alias Speed = Float
type alias Distance = Float 
type alias Time = Float
type Variable = Speed | Distance | Time

type Calculation = TimeCalc Speed Distance | DistanceCalc Speed Time | SpeedCalc Distance Time | None

type alias Model = {
  speed : Maybe Float,
  distance : Maybe Float,
  time : Maybe Float,
  result : Maybe Float
}

type Action = SpeedChange (Maybe Float) | 
  DistanceChange (Maybe Float) | 
  TimeChange (Maybe Float) | 
  Go |
  Noop

calculate : Calculation -> Maybe Float
calculate calc = 
  case calc of
    TimeCalc speed distance -> Just <| distance / speed 
    DistanceCalc speed time -> Just <| speed * time
    SpeedCalc distance time -> Just <| distance / time
    None -> Nothing

calculate' : Model -> Calculation -> Model
calculate' model calc = 
  case calc of
    TimeCalc speed distance -> { model | time <- Just <| distance / speed } 
    DistanceCalc speed time -> { model | distance <- Just <| speed * time }
    SpeedCalc distance time -> { model | speed <- Just <| distance / time }
    None -> model

variableInput : Signal.Address Action -> (Maybe Float -> Action) -> Maybe Float -> Html
variableInput address action number =
  let 
    number' = 
      case number of 
        Nothing -> ""
        Just v -> toString v
    text = 
      case List.head <| String.split "Change" <| toString <| action Nothing of
        Just v -> v
        Nothing -> ""

  in
    div [
      class "small-12 medium-4 large-4 columns input_container"
    ]
    [
      input [
            value number',
            class "user_input",
            placeholder <| text, 
            on "input" targetValue (Signal.message address << action << Result.toMaybe << String.toFloat) ] 
            []
    ]

model : Model
model = {
  speed = Nothing,
  distance = Nothing,
  time = Nothing,
  result = Nothing }

goButton address result =
  let
    buttonText = case result of
      Nothing -> "Go"
      Just v -> toString v
  in
    button 
      [ class "btn_calculate", onClick address Go ]
      [ text buttonText ]

view address model = 
  div [] [

    div 
      [
        class "row wrapper"
      ]
      [ variableInput address SpeedChange model.speed,
        variableInput address DistanceChange model.distance,
        variableInput address TimeChange model.time ],
    div [ class "row" ]
      [div [ class "small-12 medium-12 large-12 columns btn_container"] 
        [ goButton address model.result ] ]
  ]

whichCalc : Maybe Speed -> Maybe Distance -> Maybe Time -> Calculation
whichCalc speed distance time = 
  let 
    vars = log "vars" [speed, distance, time]
  in
    case vars of
      Nothing::Nothing::Nothing::[] -> None
      Just speed::Just distance::Nothing::[] -> TimeCalc speed distance 
      Just speed::Nothing::Just time::[] -> DistanceCalc speed time
      Nothing::Just distance::Just time::[] -> SpeedCalc distance time
      _ -> None

whichCalc' : Model -> Calculation
whichCalc' model = whichCalc model.speed model.distance model.time

resetResult : Model -> Model 
resetResult model = { model | result <- Nothing }

update : Action -> Model -> Model
update action model = 
  case action of
    SpeedChange speed -> resetResult { model | speed <- speed }
    DistanceChange distance -> resetResult { model | distance <- distance }
    TimeChange time -> resetResult { model | time <- time }
    Noop -> model
    Go -> { model | result <- calculate <| whichCalc' model }

update' : Action -> Model -> Model
update' action model = 
  let 
    model' = 
      case action of
        SpeedChange speed ->  { model | speed <- speed }
        DistanceChange distance -> { model | distance <- distance }
        TimeChange time -> { model | time <- time }
        Noop -> model
  in
    update Go model'

actionsMailbox : Signal.Mailbox Action
actionsMailbox = Signal.mailbox Noop

model' : Signal.Signal Model
model' = Signal.foldp
  update'
  model
  actionsMailbox.signal


main = Signal.map (view actionsMailbox.address) model'