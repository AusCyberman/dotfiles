{-# LANGUAGE TupleSections #-}
module Polybar
    ( switchMoveWindowsPolybar
    , polybarColour
    , polybarUnderline
    , polybarUnderlineWithColor
    , polybarPP)
where

import DynamicLog
import System.IO.Unsafe
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicIcons
import XMonad
import Data.Maybe
import qualified Data.Map                            as M
import Data.List
import ExtraState
import qualified XMonad.StackSet as S
import qualified XMonad.Util.ExtensibleState as XS
--Process Colours
type Colour = String
polybarColour :: Char -> Colour -> String -> String
polybarColour area (_:color) text = "%{" ++ [area] ++ color ++ "}" ++ text ++ "%{" ++ area:"--}"


colourCurrent = "#f9f9f9"
colourVisible = "#5AB1BB"
colourHidden = "#ffd1dc"
colourHiddenNoWindows = "#343434"
polybarPP ws =  def {
    {-ppCurrent = polybarWorkspace (polybarUnderlineWithColor "#FFCFD1" . polybarColour 'F' "#FFDB9E" ) ws False
    , ppHidden = polybarWorkspace (polybarColour 'F' "#E88B84") ws True
    , ppVisible = polybarWorkspace (polybarColour 'F' "#FFC9AB"  . wrap "[" "]") ws True
    , ppHiddenNoWindows = polybarWorkspace (polybarColour 'F' "#5754B3") ws True -}
    ppCurrent =  polybarColour 'F' colourCurrent . iconCurrent
    , ppHidden =  polybarColour 'F' colourHidden . iconHidden
    , ppVisible  = polybarColour 'F' colourVisible . iconCurrent 
    , ppHiddenNoWindows = polybarColour 'F' colourHiddenNoWindows . iconHidden
    , ppTitleSanitize = take 70
    , ppTitle = polybarColour 'F' "#FFFFFF"
    , ppSep = polybarColour 'F' "#4D3636" " | "
    , ppOutput = io . appendFile "/tmp/.xmonad-workspace-log" . flip (++) "\n"  . xmonadPolybarAction 4 "nextws" . xmonadPolybarAction 5 "prevws"
    , ppLayout =  xmonadPolybarAction  1 "next-layout" . xmonadPolybarAction 3 "default-layout"
--    , ppOrder = \(x:_:y) -> x:y
    }
switchMoveWindowsPolybar :: PP -> PP
switchMoveWindowsPolybar pp = pp
            { ppCurrent = switchAndMove (ppCurrent pp)
            , ppHidden = switchAndMove (ppHidden pp)
            , ppVisible = switchAndMove (ppVisible pp)
            , ppHiddenNoWindows = switchAndMove (ppHiddenNoWindows pp)
            }
            where switchAndMove f x =  xmonadPolybarAction 1 ("view\\\"" ++ x ++  "\\\"") . xmonadPolybarAction 3 ("moveTo\""++x++"\"") $ f x

defaultIcons = map show [1..10]
iconCurrent x
    | x`elem` defaultIcons = "\xf111"
    | otherwise = x

iconHidden x
    | x`elem` defaultIcons = "\xf10c"
    | otherwise = x


--iconCurrent = \xf10c""\xf10c"

--polybarWorkspace :: (String -> String)  -> Bool -> String -> String
--polybarWorkspace format bool str = (if bool then moveToWS str . switchWS str  else id) . format $ str
--Underline Text
polybarUnderline :: String -> String
polybarUnderline text = "%{+u}" ++ text ++ "%{-u}"
--Underline Polybar Text with Colour
polybarUnderlineWithColor :: Colour -> String -> String
polybarUnderlineWithColor color = polybarColour 'u' color . polybarUnderline
