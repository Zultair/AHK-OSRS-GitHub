#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% 

/*
All scripts have only been tested on the native OSRS client (fullscreen disabled). 

The starting position for this script is in Edgeville bank, at the second-closest bank window to the furnace.
The cannon ball mold must already be in your first inventory slot (top row, leftmost column).
Run energy must be at least ~75% full and turned on.
Steel bars must be the first item of the second row in your bank (second row down from top, leftmost column).
The script will not change bank tabs in order to find items.
Your bank must open to the tab containing the steel bars by default.
Your bank PIN must have already been entered for the current login session or be disabled.

The OSRS client must be oriented North. Click on the compass icon near the minimap to orient the client properly.
The OSRS client's camera must be in highest position possible. Hold the up arrow on your keyboard until the camera stops moving.
The OSRS client must be fully zoomed out.
The OSRS client's brightness must be set to the third tick from the left.


it takes just under 162 seconds to smelt an inventory
an entire trip takes about 2m55.8s (175.84s), round up to 180s to err on side of conservatism
smelting 100 bars would take 0h 11m 6s (667s)
smelting 1,000 bars would take 1h 51m (6,667s)
smelting 10,000 bars would take 18h31m (66,667s)

ListLines ;show log of all commands executed by script thus far, this will be updated periodically throughout the script
WinMove, 0, 0
ControlFocus, , 13552 ;refocus control on game client
SetTimer, Update, 1000 ;update the LineLines log every X seconds

*/

;ControlFocus , , VirtualBox.exe

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Persistent

SetTimer, LogoutDisconnectCheck, 3000 ;check if client has been logged out or disconnected once every X seconds

OrientClient() ;orient to client coordinates
OpenBank() ;start script by calling first function

OpenBank()
	{
	Global
	Random, varyby11, -11, 11
	Random, varyby5, -5, 5
	MouseMove, ox+varyby11+260, oy+varyby5+188, 0 ;open bank from starting position
		Random, wait200to500milis, 200, 500
		Sleep, wait200to500milis+500
			Click, down
				Random, wait5to200milis, 5, 200
				Sleep, wait5to200milis
			Click, up
				Random, DoubleClickRoll, 1, 20 ;chance to double-click
					if DoubleClickRoll = 1
						{
						Random, wait90to250milis, 90, 250
						Sleep, wait90to250milis
							Click, down
								Random, wait5to200milis, 5, 200
								Sleep, wait5to200milis
							Click, up
						}					
	Loop, 3
		{
		Loop, 150 ;wait for bank screen to appear
			{
			PixelSearch, BankWindowX, BankWindowY, ox+360, oy+315, ox+360, oy+315, 0x42b2f4, 3, Fast
				if ErrorLevel = 0
					Deposit()
				else
					{
					Random, wait5to10milis, 5, 10
					Sleep, wait5to10milis ;wait 5-10sec in total for bank screen to appear
					}
			} ;if loop fails, try clicking on bank again -- try 3 times before aborting macro
			Random, varyby11, -11, 11
			Random, varyby5, -5, 5
			MouseMove, ox+varyby11+260, oy+varyby5+188, 0 ;open bank from starting position (again)
				Random, wait200to500milis, 200, 500
				Sleep, wait200to500milis+500
					Click, down
						Random, wait5to200milis, 5, 200
						Sleep, wait5to200milis
					Click, up
						Random, DoubleClickRoll, 1, 20 ;chance to double-click on bank
							if DoubleClickRoll = 1
								{
								Random, wait90to250milis, 90, 250
								Sleep, wait90to250milis
									Click, down
										Random, wait5to200milis, 5, 200
										Sleep, wait5to200milis
									Click, up
								}
		}
		Gui, Destroy
		SetTimer, LogoutDisconnectCheck, Off ;stop checking for client logout
		Gui, Add, Text, ,AbortLogout called because cant open bank
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Random, wait4to8sec, 4000, 8000
			Sleep, wait4to8sec
			AbortLogout()
			ExitApp
	}
		
Deposit()
	{
	Global
	Gui, Destroy ;deposit inventory
	Gui, Add, Text, ,Depositing inventory ...
	Gui, Show, Y15, Msgbox
		Random, wait300to1500milis, 300, 1500
		Sleep, wait300to1500milis
			Random, varyby10, -10, 10
			Random, varyby9, -9, 9
			MouseMove, ox+varyby10+620, oy+varyby9+228, 0 ;second item in inventory
				Random, wait300to1500milis, 300, 1500
				Sleep, wait300to1500milis
					Click, down, right
						Random, wait5to200milis, 5, 200
						Sleep, wait5to200milis
					Click, up, right
		Random, wait300to1500milis, 300, 1500
		Sleep, wait300to1500milis
			Random, varyby25, -25, 25
			Random, varyby5, -5, 5
			MouseMove, varyby25+0, varyby5+100, 0, R ;second inventory spot Deposit-All right-click option
				Random, wait300to1500milis, 300, 1500
				Sleep, wait300to1500milis
					Click, down
						Random, wait5to200milis, 5, 200
						Sleep, wait5to200milis
					Click, up
	Loop, 3
		{
		Loop, 150 ;wait for inventory to be deposited
			{
			PixelSearch, InvSlot2EmptyX,InvSlot2EmptyY, ox+620, oy+220, ox+620, oy+220, 0x3a424b, 5, Fast
				if ErrorLevel = 0
					Withdrawal()
				else
					{
					Random, wait5to10milis, 5, 10
					Sleep, wait5to10milis ;wait 5-10sec total for inv to be deposited
					}
			} ;if loop fails, try depositing inv again -- try 3 times before aborting macro
			Random, wait300to1500milis, 300, 1500
			Sleep, wait300to1500milis
				Random, varyby10, -10, 10
				Random, varyby9, -9, 9
				MouseMove, ox+varyby10+620, oy+varyby9+228, 0 ;second item in inventory
					Random, wait300to1500milis, 300, 1500
					Sleep, wait300to1500milis
						Click, down, right
							Random, wait5to200milis, 5, 200
							Sleep, wait5to200milis
						Click, up, right
			Random, wait300to1500milis, 300, 1500
			Sleep, wait300to1500milis
				Random, varyby25, -25, 25
				Random, varyby5, -5, 5
				MouseMove, varyby25+0, varyby5+100, 0, R ;second inventory spot Deposit-All right-click option
				Random, wait300to1500milis, 300, 1500
				Sleep, wait300to1500milis
						Click, down
							Random, wait5to200milis, 5, 200
							Sleep, wait5to200milis
						Click, up
		}
		Gui, Destroy
		SetTimer, LogoutDisconnectCheck, Off
		Gui, Add, Text, ,AbortLogout called because cant deposit inventory
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Random, wait4to8sec, 4000, 8000
			Sleep, wait4to8sec
			Random, varyby9, -9, 9
			Random, varyby8, -8, 8
			MouseMove, varyby9+486, varyby8+23, 0 ;X in top right corner of bank window
				Random, wait300to1500milis, 300, 1500
				Sleep, wait300to1500milis
					Click, down
						Random, wait5to200milis, 5, 200
						Sleep, wait5to200milis
					Click, up
		AbortLogout()
		ExitApp
	}
		
Withdrawal()
	{
	Global
	Loop, 200 ;look for steel bars
		{
		PixelSearch, BarsX, BarsY, ox+74, oy+119, ox+76, oy+126, 0x00ffff, 3, Fast
			if ErrorLevel = 0
				Goto, Barswithdrawal
			else
				Sleep, 1
		}
		Gui, Destroy
		Gui, Add, Text, ,AbortLogout called because out of steel bars
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Random, wait4to8sec, 4000, 8000
			Sleep, wait4to8sec
			AbortLogout()
			ExitApp
	Barswithdrawal:

	;withdrawal steel bars
	Gui, Destroy
	Gui, Add, Text, ,Withdrawing bars ...
	Gui, Show, Y15, Msgbox
		Random, wait300to1500milis, 300, 1500
		Sleep, wait300to1500milis
			Random, varyby11, -11, 11
			Random, varyby10, -10, 10
			MouseMove, ox+varyby11+88, oy+varyby10+136, 0 ;first item in second row of bank
				Random, wait300to1500milis, 300, 1500
				Sleep, wait300to1500milis
					Click, down, right
						Random, wait5to200milis, 5, 200
						Sleep, wait5to200milis
					Click, up, right
		Random, wait300to1500milis, 300, 1500
		Sleep, wait300to1500milis
			Random, varyby25, -25, 25
			Random, varyby5, -5, 5
			MouseMove, varyby25+0, varyby5+100, 0, R ;Withdrawal-All right-click option
				Random, wait300to1500milis, 300, 1500
				Sleep, wait300to1500milis
					Click, down
						Random, wait5to200milis, 5, 200
						Sleep, wait5to200milis
					Click, up
	Loop, 3
		{
		Loop, 150 ;wait for bars to appear in inventory
			{
				PixelSearch, InvBarsX,InvBarsY, ox+580, oy+267, ox+580, oy+267, 0x868690, 15, Fast
				if ErrorLevel = 0
					FurnaceGo()
				else
					{
					Random, wait5to10milis, 5, 10
					Sleep, wait5to10milis ;wait 5-10sec total for inv to be deposited
					}
			} ;if loop fails, try again -- try 3 times before aborting macro
			Random, wait300to1500milis, 300, 1500
			Sleep, wait300to1500milis
				Random, varyby10, -10, 10
				Random, varyby9, -9, 9
				MouseMove, ox+varyby10+88, oy+varyby9+136, 0 ;location of bars in bank
					Random, wait300to1500milis, 300, 1500
					Sleep, wait300to1500milis
						Click, down, right
							Random, wait5to200milis, 5, 200
							Sleep, wait5to200milis
						Click, up, right
			Random, wait300to1500milis, 300, 1500
			Sleep, wait300to1500milis
				Random, varyby25, -25, 25
				Random, varyby5, -5, 5
				MouseMove, varyby25+0, varyby5+100, 0, R ;Withdrawal-All right-click option
					Random, wait300to1500milis, 300, 1500
					Sleep, wait300to1500milis
						Click, down
							Random, wait5to200milis, 5, 200
							Sleep, wait5to200milis
						Click, up
		}
		Gui, Destroy
		SetTimer, LogoutDisconnectCheck, Off
		Gui, Add, Text, ,AbortLogout called because cant deposit inventory
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Random, wait300to1500milis, 300, 1500
			Sleep, wait300to1500milis
				Random, varyby9, -9, 9
				Random, varyby8, -8, 8
				MouseMove, varyby9+486, varyby8+23, 0 ;X in top right corner of bank window
					Random, wait300to1500milis, 300, 1500
					Sleep, wait300to1500milis
						Click, down
							Random, wait5to200milis, 5, 200
							Sleep, wait5to200milis
						Click, up
		AbortLogout()
		ExitApp
	}
		
FurnaceGo()
	{
	Global
	Gui, Destroy
	Random, BankCloseRoll, 1, 4 ;1 in X chance to close bank instead if immediately clicking on minimap
		if BankCloseRoll = 1
			{
			Random, wait300to1500milis, 300, 1500
			Sleep, wait300to1500milis
				Random, varyby9, -9, 9
				Random, varyby8, -8, 8
				MouseMove, ox+varyby9+486, oy+varyby8+23, 0 ;close button in top right corner of bank window
					Random, wait300to1500milis, 300, 1500
					Sleep, wait300to1500milis
						Click, down
							Random, wait5to200milis, 5, 200
							Sleep, wait5to200milis
						Click, up
							Random, wait300to1500milis, 300, 1500
							Sleep, wait300to1500milis
			}
	Loop, 150 ;look for furnace on minimap
		{
		PixelSearch, FurnaceGoX, FurnaceGoY, ox+692, oy+62, ox+696, oy+65, 0x1e73fe, 5, Fast
			if ErrorLevel = 0
				Goto, FurnaceGo
			else
				{
				Random, wait5to10milis, 5, 10
				Sleep, wait5to10milis ;wait 5-10sec total
				}
		}
		Gui, Destroy
		SetTimer, LogoutDisconnectCheck, Off
		Gui, Add, Text, ,AbortLogout called because cant find furnace on minimap
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Random, wait4to8sec, 4000, 8000
			Sleep, wait4to8sec
			AbortLogout()
			ExitApp
	FurnaceGo:
	Loop, 3
		{
		Random, varyby6, 0, 6
		Random, varyby1, 0, 1
		MouseMove, ox+varyby6+690, oy+varyby1+63, 0 ;furnace on minimap
			Random, wait200to500milis, 200, 500
			Sleep, wait200to500milis+500
				Click, down
					Random, wait5to200milis, 5, 200
					Sleep, wait5to200milis
				Click, up
					Random, DoubleClickRoll, 1, 25 ;chance to double-click
						if DoubleClickRoll = 1
							{
							Random, wait90to250milis, 90, 250
							Sleep, wait90to250milis
								Click, down
									Random, wait5to200milis, 5, 200
									Sleep, wait5to200milis
								Click, up
							}
			Gui, Destroy
			Gui, Add, Text, ,Checking if at furnace yet
			Gui, Show, Y15, Msgbox
		Random, wait7ishto9sec, 6800, 9000
		Sleep, wait7ishto9sec
			Loop, 25 ;wait until transportation arrow appears in right edge of minimap
				{
				FurnaceAtCheck:
				PixelSearch, FurnaceAtX, FurnaceAtY, ox+711, oy+94, ox+711, oy+94, 0x1b67db, 1, Fast
					if ErrorLevel = 0
						Smelt()
					else ;if not at furnace, check if stuck one tile south
						{
						PixelSearch, StuckSX, StuckSY, ox+676, oy+125, ox+687, oy+125, 0xebf0f2, 25, Fast
							if ErrorLevel = 0
								{
								Random, varyby10, -10, 10
								Random, varyby5, -5, 5
								MouseMove, ox+varyby5+296, oy+varyby10+145, 0 ;location of furnace from stuck s
									Random, wait200to900milis, 200, 900 
									Sleep, wait200to900milis
									Sleep, wait200to900milis
										Click, down
											Sleep, wait5to200milis, 5, 200
											Sleep, wait5to200milis
										Click, up
											Random, wait2to4sec, 2000, 4000
											Sleep, wait2to4sec
												Goto, FurnaceAtCheck ;recheck location after correcting to make sure character at furnace before continuing
								}
							else ;if not stuck one tile south, check if stuck one tile west
								{
								PixelSearch, StuckWX, StuckWY, ox+679, oy+130, ox+679, oy+130, 0xf5f0f3, 25, Fast
									if ErrorLevel = 0
										{
										Random, varyby10, -10, 10
										Random, varyby5, -5, 5
										MouseMove, ox+varyby5+318, oy+varyby10+165, 0 ;location of furnace from stuck w
											Random, wait200to900milis, 200, 900 
											Sleep, wait200to900milis
												Click, down
													Random, wait5to200milis, 5, 200
													Sleep, wait5to200milis
												Click, up
													Random, wait2to4sec, 2000, 4000
													Sleep, wait2to4sec
														Goto, FurnaceAtCheck
										}
									else ;if not stuck one tile west or south, check if stuck one tile north-west (diagonally)
										{
										PixelSearch, StuckNWX, StuckNWY, ox+640, oy+13, ox+643, oy+13, 0xebf0f2, 25, Fast
											if ErrorLevel = 0
												{
												Random, varyby10, -10, 10
												Random, varyby5, -5, 5
												MouseMove, ox+varyby5+320, oy+varyby10+192, 0 ;location of furnace from stuck nw
													Random, wait200to900milis, 200, 900 
													Sleep, wait200to900milis
														Click, down
															Random, wait5to200milis, 5, 200
															Sleep, wait5to200milis
														Click, up
															Random, wait2to4sec, 2000, 4000
															Sleep, wait2to4sec
																Goto, FurnaceAtCheck
												}
											else ;check if stuck in ne corner
												{
												PixelSearch, StuckNEX, StuckNEY, ox+704, oy+106, ox+704, oy+106, 0x1b67db, 15, Fast
												if ErrorLevel = 0
													{
													Random, varyby10, -10, 10
													Random, varyby5, -5, 5
													MouseMove, ox+varyby5+268, oy+varyby10+221, 0 ;location of furnace from stuck ne
														Random, wait200to900milis, 200, 900 
														Sleep, wait200to900milis
															Click, down
																Sleep, wait5to200milis, 5, 200
																Sleep, wait5to200milis
															Click, up
																Random, wait2to4sec, 2000, 4000
																Sleep, wait2to4sec
																	Goto, FurnaceAtCheck
													}
												else ;if not at furnace and not stuck at any known location yet, wait before loop expires 
													{
													Random, wait5to10milis, 5, 10
													Sleep, wait5to10milis
													}
												}
										}
								}
						}
				}
		}
		;if loop expires and still not at furnace or any other known "stuck" locaiton, logout
		Gui, Destroy
		SetTimer, LogoutDisconnectCheck, Off
		Gui, Add, Text, ,AbortLogout called because cant reach furnace
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Random, wait4to8sec, 4000, 8000
			Sleep, wait4to8sec
			AbortLogout()
			ExitApp
	}
		
Smelt()
	{
	Global
	TrySmelt:
	Gui, Destroy
	Random, wait100to500milis, 100, 500
	Sleep, wait100to500milis
		Random, varyby10, -12, 12
		Random, varyby4, -4, 4
		MouseMove, ox+varyby4+300, oy+varyby10+162, 0 ;click on furnace to open smelting chat menu
			Random, wait300to1500milis, 300, 1500
			Sleep, wait300to1500milis
				Click, down
					Random, wait5to200milis, 5, 200
					Sleep, wait5to200milis
				Click, up
	Loop, 3
		{
		Loop, 150 ;wait until cannonball icon appears in chat menu
			{
			PixelSearch, BeginSmeltX, BeginSmeltY, ox+304, oy+394, ox+306, oy+394, 0xabb3b5, 5, Fast
				if ErrorLevel = 0
					Goto, BeginSmelt
				else
					{
					Random, wait5to10milis, 5, 10
					Sleep, wait5to10milis ;wait 5-10sec total
					}
			} ;if loop fails, try clicking on furnace again if cannonball icon does not appear in chat menu
			Random, wait300to1500milis, 300, 1500
			Sleep, wait300to1500milis
				Random, varyby10, -12, 12
				Random, varyby4, -4, 4
				MouseMove, ox+varyby4+300, oy+varyby10+162, 0 ;click on furnace to open smelting chat menu
					Random, wait300to1500milis, 300, 1500
					Sleep, wait300to1500milis
						Click, down
							Random, wait5to200milis, 5, 200
							Sleep, wait5to200milis
						Click, up
		}
		Gui, Destroy
		SetTimer, LogoutDisconnectCheck, Off
		Gui, Add, Text, ,AbortLogout called because cant see cannonball icon in chat menu
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Random, wait4to8sec, 4000, 8000
			Sleep, wait4to8sec
			AbortLogout()
			ExitApp
	BeginSmelt:

		Random, wait500to2000milis, 500, 2000
		Sleep, wait500to2000milis
	Send {Space down} ;hit space bar to begin smelting
		Random, wait20to150milis, 20, 150
		Sleep, wait20to150milis
	Send {Space up}
		Random, wait500to8000milis, 500, 8000
		Sleep, wait500to8000milis
			Random, SelectChatRoll, 1, 200
				if SelectChatRoll = 1 ;chance per inventory to enter predetermined text into chat (chance should be lower than BriefLogout chances to prevent duplicate messages appearing to the same people)
					{
					SelectChat()
					Random, wait500to8000milis, 500, 8000
					Sleep, wait500to8000milis
					Goto, TrySmelt
					}
			Random, CheckStatsRoll, 1, 10
				if CheckStatsRoll = 1 ;chance per inventory to check skill stat and xp while smelting
					{
					Random, TimerDuration, -1000, -120000
					SetTimer, CheckStatsSmithing, %TimerDuration% ;check stats at some random point while smelting
					}
			Gui, Destroy
			Random, varyby765, 0, 765
			Random, varyby503, 0, 503
			MouseMove, ox+varyby765, oy+varyby503, 0 ;move mouse to a random spot on the screen
			Sleep, 20000 ;wait at least X seconds before checking for empty inventory spot in order to smelt partial inventories
		Gui, Destroy
		Gui, Add, Text, ,Waiting for smelting to finish...
		Gui, Show, Y15, Msgbox
		Loop, 160 ;wait for smelting to finish
			{
			PixelSearch, DoneSmeltingX, DoneSmeltingY, ox+705, oy+439, ox+717, oy+454, 0x868690, 50, Fast
				if ErrorLevel ;if done smelting...
					{
					Gui, Destroy
					Random, wait500to2000milis, 500, 2000
					Sleep, wait500to2000milis
						Random, RandomSleepRoll, 1, 2
						if RandomSleepRoll = 1 ;chance per inventory to briefly "stall"
							{
							RandomSleep()
							GoToBank()
							}
						else
							{
							Random, wait500to3000milis, 500, 3000
							Sleep, wait500to3000milis
							GoToBank()
							}
					}
				else
					{
					Sleep, 1000
						PixelSearch, LevelUpX, LevelUpY, ox+459, oy+387, ox+462, oy+390, 0x800000, 2, Fast ;look for smithing level up while smelting
							if ErrorLevel = 0
								{
									Random, wait1to5sec, 1000, 5000
									Sleep, wait1to5sec
										Random, varyby10, -12, 12
										Random, varyby4, -4, 4
										MouseMove, ox+varyby4+300, oy+varyby10+162, 0 ;click on furnace to open smelting chat menu
											Random, wait300to1500milis, 300, 1500
											Sleep, wait300to1500milis
												Click, down
													Random, wait5to200milis, 5, 200
													Sleep, wait5to200milis
												Click, up
											Random, wait300to1500milis, 300, 1500
											Sleep, wait300to1500milis
									Loop, 2
										{
										Loop, 150 ;wait until cannonball icon appears in chat menu
											{
											PixelSearch, BeginSmeltX, BeginSmeltY, ox+304, oy+394, ox+306, oy+394, 0xabb3b5, 5, Fast
												if ErrorLevel = 0
													Goto, BeginSmelt
												else
													{
													Random, wait5to10milis, 5, 10
													Sleep, wait5to10milis ;wait 5-10sec total
													}
											} ;try clicking on furnace again if cannonball icon does not appear in chat menu
											Random, wait300to1500milis, 300, 1500
											Sleep, wait300to1500milis
												Random, varyby10, -12, 12
												Random, varyby4, -4, 4
												MouseMove, ox+varyby4+300, oy+varyby10+162, 0 ;click on furnace to open smelting chat menu
													Random, wait300to1500milis, 300, 1500
													Sleep, wait300to1500milis
														Click, down
															Random, wait5to200milis, 5, 200
															Sleep, wait5to200milis
														Click, up
										}
										Gui, Destroy
										SetTimer, LogoutDisconnectCheck, Off 
										Gui, Add, Text, ,AbortLogout called because cant see cannonball icon in chat menu after lvl up
										Gui, Show, Y15, Msgbox
										SoundPlay, AbortLogoutAlarm.mp3
											Random, wait4to8sec, 4000, 8000
											Sleep, wait4to8sec
											AbortLogout()
											ExitApp
								}
					
					}
			}
			Random, wait500to3000milis, 500, 3000
			Sleep, wait500to3000milis
			GoToBank()
	}
	
GoToBank()
	{
	Global
	Loop, 150 ;look for bank on minimap
		{
		ImageSearch, BankReturnX, BankReturnY, ox+585, oy+108, ox+587, oy+110, BankOrient.png
			if ErrorLevel = 0
				Goto, BankReturn
			else
				{
				Random, wait5to10milis, 5, 10
				Sleep, wait5to10milis
				}
		}
	Loop, 5 ;try looking for bank again searching whole minimap (2nd try)
		{
		ImageSearch, BankReturnX, BankReturnY, ox+565, oy+3, ox+722, oy+162, BankOrient.png
			if ErrorLevel = 0
				Goto, BankReturn
			else
				{
				Random, wait5to10milis, 5, 10
				Sleep, wait5to10milis
				}
		}
		Gui, Destroy
		SetTimer, LogoutDisconnectCheck, Off
		Gui, Add, Text, ,AbortLogout called because cant find bank after smelting
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Random, wait4to8sec, 4000, 8000
			Sleep, wait4to8sec
			AbortLogout()
			ExitApp
	BankReturn:

	Random, varyby2, 0, 2
	Random, varyby4, 0, 4
	MouseMove, ox+varyby2+589, oy+varyby4+103, 0 ;bank on minimap
		Random, wait200to500milis, 200, 500
		Sleep, wait200to500milis+500
			Click, down
				Random, wait5to200milis, 5, 200
				Sleep, wait5to200milis
			Click, up
				Random, DoubleClickRoll, 1, 10 ;chance to double-click
					if DoubleClickRoll = 1
						{
						Random, wait90to250milis, 90, 250
						Sleep, wait90to250milis
							Click, down
								Random, wait5to200milis, 5, 200
								Sleep, wait5to200milis
							Click, up
						}
	BankReturnWait:
	
		Random, wait4to8sec, 4000, 8000
		Sleep, wait4to8sec ;wait until arrived at bank booth
	Loop, 150 ;look for bank booth
		{
		PixelSearch, BankAtX, BankAtY, ox+595, oy+47, ox+595, oy+47, 0xe78d7b, 1, Fast
			if ErrorLevel = 0
				Goto, BankAt
			else
				{
				Random, wait8to10milis, 8, 10
				Sleep, wait8to10milis
				}
		}
		Gui, Destroy
		SetTimer, LogoutDisconnectCheck, Off
		Gui, Add, Text, ,AbortLogout called because cant reach bank
		Gui, Show, Y15, Msgbox
		SoundPlay, AbortLogoutAlarm.mp3
			Random, wait4to8sec, 4000, 8000
			Sleep, wait4to8sec
			AbortLogout()
			ExitApp

	BankAt:

	Random, wait160to1600milis, 160, 1600
	Sleep, wait160to1600milis ;wait for character to stop moving
/*	
		Random, BriefLogoutRoll, 1, 50
			if BriefLogoutRoll = 1 ;chance per inventory to logout briefly to simulate a quick break
				{
				Gui, Destroy
				SetTimer, LogoutDisconnectCheck, Off
				Gui, Add, Text, ,BriefLogout randomly called
				Gui, Show, Y15, Msgbox
					Random, wait4to8sec, 4000, 8000
					Sleep, wait4to8sec
					BriefLogout()
				}

		Random, AbortLogoutRoll, 1, 100
			if AbortLogoutRoll = 1 ;chance per inventory to logout and stop macro completely
				{
				Gui, Destroy
				SetTimer, LogoutDisconnectCheck, Off
				Gui, Add, Text, ,AbortLogout randomly called
				Gui, Show, Y15, Msgbox
					Random, wait4to8sec, 4000, 8000
					Sleep, wait4to8sec
					AbortLogout()
				}
*/
	OpenBank()
	}
		
SelectChat()
	{
	Global
	SelectChat:
		Random, wait500to900milis, 500, 900
		Sleep, wait500to900milis
			Random, varyby10, -10, 10
			Random, varyby9, -9, 9
			MouseMove, ox+varyby10+258, oy+varyby9+144, 0 ;click on rock
				Random, wait200to500milis, 200, 500
				Sleep, wait200to500milis
					Click, down
						Random, wait5to200milis, 5, 200
						Sleep, wait5to200milis
					Click, up
						Random, DoubleClickRoll, 1, 32 ;small chance to double-click
							if DoubleClickRoll = 1
								{
								Random, wait90to250milis, 90, 250
								Sleep, wait90to250milis
									Click, down
										Random, wait5to200milis, 5, 200
										Sleep, wait5to200milis
									Click, up
								Random, wait300to600milis, 300, 600
								Sleep, wait300to600milis
								Gui, Destroy
								}
		Random, SelectChat, 1, 14 ;if macro decides to chat, determine which message it will type, with equal chances for each message
			if SelectChat = 1
				{
				Send {Raw}wonder how many bots here
					Random, wait400to700milis, 400, 700
					Sleep, wait400to700milis+1000
				Send {Enter}
				Return
				}
			if SelectChat = 2
				{
				Send {Raw}so board
					Random, wait400to700milis, 400, 700
					Sleep, wait400to700milis+1000
				Send {Enter}
				}
			if SelectChat = 3
				{
				Send {Raw}why is smithing so slow to lvl
					Random, wait400to700milis, 400, 700
					Sleep, wait400to700milis+1000
				Send {Enter}
				}
			if SelectChat = 5
				{
				Send {Raw}any other hoomanss?
					Random, wait400to700milis, 400, 700
					Sleep, wait400to700milis+1000
				Send {Enter}
				}
			if SelectChat = 6
				{
				Send {Raw}alguien habla espanol?
					Random, wait400to700milis, 400, 700
					Sleep, wait400to700milis+1000
				Send {Enter}
				}
			if SelectChat = 7
				{
				Send {Raw}meow!
					Random, wait400to700milis, 400, 700
					Sleep, wait400to700milis+1000
				Send {Enter}
				}
			if SelectChat = 8
				{
				Send {Raw}this place must be bot heaven
					Random, wait400to700milis, 400, 700
					Sleep, wait400to700milis+1000
				Send {Enter}
				}
			if SelectChat = 9
				{
				Send {Raw}botopolis
					Random, wait400to700milis, 400, 700
					Sleep, wait400to700milis+1000
				Send {Enter}
				}
			if SelectChat = 10
				{
				Send {Raw}mmmmmmeow
					Random, wait400to700milis, 400, 700
					Sleep, wait400to700milis+1000
				Send {Enter}
				}
			if SelectChat = 11
				{
				Send {Raw}making cannonballsz is sooo fun
					Random, wait400to700milis, 400, 700
					Sleep, wait400to700milis+1000
				Send {Enter}
				}
			if SelectChat = 12
				{
				Send {Raw}smelting = fun
					Random, wait400to700milis, 400, 700
					Sleep, wait400to700milis+1000
				Send {Enter}
				}
			if SelectChat = 13
				{
				Send {Raw}only 12m xp left till 99!
					Random, wait400to700milis, 400, 700
					Sleep, wait400to700milis+1000
				Send {Enter}
				}
			if SelectChat = 14
				{
				Send {Raw}estoy aburrido
					Random, wait400to700milis, 400, 700
					Sleep, wait400to700milis+1000
				Send {Enter}
				}
			else
				Sleep, 1
		Gui, Destroy
		Gui, Add, Text, ,SelectChat (%SelectChat%) rolled ...
		Gui, Show, Y15, Msgbox
			Random, wait300to600milis, 300, 600
			Sleep, wait300to600milis
		Gui, Destroy
	Return
	}

CheckStatsSmithing:
	CheckStatsSmithing()
	Return
	
LogoutDisconnectCheck:
	LogoutCheck()
			if LogoutCheck() = 1 ;if function returns positive, look for bank to restart macro
				AfterLogin()
	DisconnectCheck()
			if DisconnectCheck() = 1
				AfterLogin()
	Return
	
AfterLogin() ;function called if LogoutCheck or DisconnectCheck return positive
	{
	GoToBank()
	}
	
;hotkeys
z::
	{
	Gui, Destroy
	ListLines
	Pause
	}
	
x::
	{
	Gui, Destroy
	ListVars
	Pause
	}

shift:: ;manual kill switch — ADD listlines LOGGING
	{
	Gui, Destroy
	ExitApp
	}
