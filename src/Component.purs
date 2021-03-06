module Component where

import Prelude

import Control.Monad.Aff (Aff)
import Control.Monad.Aff.Console (CONSOLE, log)

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

data Query a = ToggleState a | HandleInput String a

type State = { on :: Boolean, clickCount :: Int, title :: String }

component :: forall eff. H.Component HH.HTML Query String Void (Aff (console :: CONSOLE | eff))
component =
  H.component
    { initialState: \i -> initialState { title = i }
    , render
    , eval
    , receiver: HE.input HandleInput
    }
  where

  initialState :: State
  initialState = { on: false, clickCount: 0, title: "Initial Title" }

  render :: State -> H.ComponentHTML Query
  render state =
    HH.div_
      [ HH.h1_
          [ HH.text state.title ]
      , HH.p_
          [ HH.text "Why not toggle this button:" ]
      , HH.button
          [ HE.onClick (HE.input_ ToggleState) ]
          [ HH.text
              if not state.on
              then "Don't push me"
              else "I said don't push me!"
          ]
      , HH.h3_
          [ HH.text $ "Number of clicks: " <> show state.clickCount ]
      ]

  eval :: Query ~> H.ComponentDSL State Query Void (Aff (console :: CONSOLE | eff))
  eval = case _ of
    ToggleState next -> do
      H.liftAff $ log "Toggle State"
      H.modify (\state -> state { on = not state.on, clickCount = state.clickCount + 1 })
      pure next
    HandleInput title next -> do
      H.liftAff $ log title
      H.modify (\state -> state { title = title })
      pure next
