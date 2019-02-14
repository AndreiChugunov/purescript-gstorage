module Storage.Core
  ( generateSignedUrl
  , uploadFile
  , createStorage
  , Storage
  ) where

import Prelude
import Data.Either (Either(..))
import Data.Function.Uncurried (Fn5) as Fn
import Data.Function.Uncurried (runFn5)
import Effect (Effect)
import Effect.Aff (Aff, Canceler, makeAff)
import Effect.Exception (Error)

foreign import data Storage :: Type

foreign import createStorage :: String -> Effect Storage

foreign import _uploadFile :: Fn.Fn5 (Error -> Effect Unit) (Unit -> Effect Unit) Storage String String (Effect Canceler)

foreign import _generateSignedUrl :: Fn.Fn5 (Error -> Effect Unit) ((Array String) -> Effect Unit) Storage String String (Effect Canceler)

uploadFile :: Storage -> String -> String -> Aff Unit
uploadFile storage bucket file = makeAff (\cb -> runFn5 _uploadFile (cb <<< Left) (cb <<< Right) storage bucket file)

generateSignedUrl :: Storage -> String -> String -> Aff (Array String)
generateSignedUrl storage bucket file = makeAff (\cb -> runFn5 _generateSignedUrl (cb <<< Left) (cb <<< Right) storage bucket file)