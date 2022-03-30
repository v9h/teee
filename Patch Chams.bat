@echo off
title ChamsFFlagPatcher.bat
color B
@echo Writing FFlags to your local roblox directory
set RobloxDirectory=%LocalAppData%\Roblox\Versions\
for /D %%G in (%RobloxDirectory%*) do (
	echo %%G
	if not exist "%%G\ClientSettings\" mkdir %%G\ClientSettings\
	echo {"FFlagRenderHighlightPass3": "True"}> %%G\ClientSettings\ClientAppSettings.json
)

@echo All done restart your roblox client to fix
@pause