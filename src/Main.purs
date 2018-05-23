module Main where

import Prelude

import Component (component)
import Control.Monad.Aff.Console (CONSOLE)
import Control.Monad.Eff (Eff)

import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Eff (console :: CONSOLE | HA.HalogenEffects ()) Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI component "Hello from Main.purs" body
