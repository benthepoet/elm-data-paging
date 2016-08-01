import Html exposing (div, text, button)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (onClick)

main = 
    beginnerProgram 
        { model = model
        , update = update
        , view = view 
        }
    
type alias Model = 
    { limit: Int
    , offset: Int
    , count: Int
    , data: List String
    }

model : Model
model = 
    { limit = 5
    , offset = 0
    , count = 0
    , data = 
        [ "A"
        , "B"
        , "C"
        , "D"
        , "E"
        , "F"
        , "G"
        , "H"
        , "I"
        , "J"]
    }
    
pageData model = 
    model.data
        |> List.drop model.offset
        |> List.take model.limit
    
type Msg = Previous | Next
    
update msg model =
    case msg of
        Previous ->
            model
        Next ->
            model

renderButtons model = 
    let
        previous = button [onClick Previous] [text "Previous"]
        next = button [onClick Next] [text "Next"]
        dataLength = List.length model.data
        upperBound = model.offset + model.limit
    in
        List.concat
            [ if model.offset > 0 then [previous] else []
            , if upperBound < dataLength then [next] else []
            ]
        
renderListItem item = 
    div [] [text item]
    
view model = 
    div []
        [ div [] (List.map renderListItem (pageData model))
        , div [] (renderButtons model)
        ]