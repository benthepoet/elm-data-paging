import Html
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Pure

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
    , headers: List String
    , data: List (List String)
    }


model : Model
model = 
    { limit = 5
    , offset = 0
    , count = 0
    , headers = 
        [ "Id"
        , "Color"
        , "Size"
        ]
    , data = 
        [ ["1", "Blue", "Small"]
        , ["2", "Red", "Large"]
        , ["3", "Yellow", "Small"]
        , ["4", "Green", "Medium"]
        , ["5", "Orange", "Large"]
        , ["6", "Purple", "Small"]
        , ["7", "Blue", "Large"]
        ]
    }
    
pageData model = 
    model.data
        |> List.drop model.offset
        |> List.take model.limit
    
type Msg = Previous | Next
    
update msg model =
    case msg of
        Previous ->
            { model | offset = model.offset - model.limit }
        Next ->
            { model | offset = model.offset + model.limit }

renderButtons model = 
    [ Html.button 
        [ Html.Attributes.class Pure.button
        , Html.Attributes.disabled (model.offset <= 0)
        , onClick Previous
        ] [Html.text "Previous"]
    , Html.button 
        [ Html.Attributes.class Pure.button
        , Html.Attributes.disabled (model.offset + model.limit >= List.length model.data)
        , onClick Next
        ] [ Html.text "Next"]
    ]
        
renderListItem item = 
    Html.tr [] 
        (List.map (\x -> Html.td [] [Html.text x]) item)

renderListItems model = 
    List.map renderListItem (pageData model)
    
renderListHeaders headers = 
    Html.tr []
        (List.map (\x -> Html.th [] [Html.text x]) headers)
    
view model = 
    Html.div [Html.Attributes.class Pure.grid]
        [ Html.div [Html.Attributes.class (Pure.unit ["1", "3"])] []
        , Html.div [Html.Attributes.class (Pure.unit ["1", "3"])] 
            [ Html.h2 [] [Html.text "Practical Elm - Data Paging"]
            , Html.div [] (renderButtons model)
            , Html.table 
                [ Html.Attributes.classList 
                    [ (Pure.table, True)
                    , (Pure.tableStriped, True)
                    ]
                ] 
                [ Html.thead [] [renderListHeaders model.headers]
                , Html.tbody [] (renderListItems model)
                ]
            ]
        , Html.div [Html.Attributes.class (Pure.unit ["1", "3"])] []    
        ]