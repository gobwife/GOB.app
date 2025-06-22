#!/bin/bash

echo ">> PURGING: Adobe, KakaoTalk, CleanMyMac, ShutterEncoder, CarelessWhisper..."

# ⛔ Adobe
sudo rm -rf /Applications/Adobe\ Acrobat*
sudo rm -rf ~/Library/Application\ Support/Adobe
sudo rm -rf ~/Library/Preferences/com.adobe.*
sudo rm -rf ~/Library/Caches/com.adobe.*
sudo rm -rf /Library/Application\ Support/Adobe
sudo rm -rf /Library/Preferences/com.adobe.*
sudo rm -rf /Library/LaunchAgents/com.adobe.*
sudo rm -rf /Library/LaunchDaemons/com.adobe.*

# ⛔ KakaoTalk
sudo rm -rf /Applications/KakaoTalk.app
sudo rm -rf ~/Library/Application\ Support/KakaoTalk
sudo rm -rf ~/Library/Preferences/com.kakao*
sudo rm -rf ~/Library/Caches/com.kakao*

# ⛔ ShutterEncoder
sudo rm -rf /Applications/Shutter\ Encoder.app
sudo rm -rf ~/Library/Application\ Support/Shutter\ Encoder
sudo rm -rf ~/Library/Preferences/com.paulpacifico.shutterencoder*
sudo rm -rf ~/Library/Caches/com.paulpacifico.shutterencoder*

# ⛔ CleanMyMac
sudo rm -rf /Applications/CleanMyMac*
sudo rm -rf ~/Library/Application\ Support/CleanMyMac*
sudo rm -rf ~/Library/Preferences/com.macpaw.CleanMyMac*
sudo rm -rf ~/Library/Caches/com.macpaw.CleanMyMac*
sudo rm -rf /Library/LaunchDaemons/com.macpaw*
sudo rm -rf /Library/Application\ Support/MacPaw

# ⛔ CarelessWhisper (maybe this is your mic/voice one)
sudo rm -rf /Applications/CarelessWhisper.app
sudo rm -rf ~/Library/Application\ Support/com.carelesswhisper.app
sudo rm -rf ~/Library/Preferences/com.carelesswhisper.app.plist

echo "✅ DONE. You can reboot now if you want."
