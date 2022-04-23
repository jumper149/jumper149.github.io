module Homepage.Server.Route.Static where

import Homepage.Application.Configured.Class
import Homepage.Configuration
import Homepage.Server.Err404
import Homepage.Server.FileServer

import Control.Monad.Logger.CallStack
import Control.Monad.Trans.Control.Identity
import Network.Wai.Trans
import Servant
import Servant.RawM.Server qualified as RawM
import WaiAppStatic.Types

type API = RawM.RawM

handler ::
  (MonadBaseControlIdentity IO m, MonadConfigured m, MonadLogger m) =>
  ServerT API m
handler = do
  directory <- configDirectoryStatic <$> configuration
  fallbackApplication <- runApplicationT application404
  logInfo "Serve static file download."
  settings <- fileServerSettings directory
  RawM.serveDirectoryWith settings {ss404Handler = Just fallbackApplication}
