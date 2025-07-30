#!/bin/sh
# macOS local admin creation

accountname=localadmin
password="SUPERsecret!"

dscl . -create /Users/$accountname
dscl . -create /Users/$accountname UserShell /bin/bash
dscl . -create /Users/$accountname RealName "IT Admin"
dscl . -create /Users/$accountname UniqueID "2001"
dscl . -create /Users/$accountname PrimaryGroupID 20
dscl . -create /Users/$accountname NFSHomeDirectory /Users/$accountname
dscl . -passwd /Users/$accountname $password
dscl . -append /Groups/admin GroupMembership $accountname
dscl . -create /Users/$accountname picture "/profilepic.png"
dscl . -create /Users/$accountname hint "Provide Password hint"
