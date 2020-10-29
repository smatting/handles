module Toy.Database where

import Data.Has
import RIO hiding (Handle)
import qualified Toy.Logger as Logger
import Toy.Types

data Handle = Handle
  { createUserH :: Text -> IO User
  }

-- boilerplate

createUser ::
  Has Handle e =>
  Text ->
  RIO e User
createUser name = do
  handle <- asks getter
  liftIO $ createUserH handle name
