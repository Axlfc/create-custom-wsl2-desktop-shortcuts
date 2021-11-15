subsys="$(echo $(uname -r) | rev | cut -d "-" -f1 | rev)"
declare wdesk="/Users/Axel F C/Desktop"
declare wsl2desk="/home/axl/Desktop"
declare ico_path="${wsl2desk}/git/icons/ico_images/"

if [ ${subsys} != "WSL2" ]; then
  echo "We don't find any WSL2 Subsystem"
  exit 1
fi

for program in "${wsl2desk}/*"; do 
  if [ ! -f "${program}" ]; then
    continue
  fi
  if "$(echo "${program}" | rev | cut -d "." -f1 | rev)" != "desktop"; then
    continue
  fi
  exec_command="$(cat "${program}" | grep -Eo "^Exec=.*" | cut -d "=" -f2-)"
  # We need a cleaner command... This might work, but need to be refined and possibly accept some arguments from Exec= line in .desktop file.

  # "SEARCH MATCHING ICON IN ico_images FOLDER STRUCTURE: "
  for icon_prog_fold in "${ico_path}/*"; do
      if [ ! -d "${folder}" ]; then
        continue
      fi
      program_keyname="$(echo "${icon_prog_fold}" | rev | cut -d "/" -f1 | rev)"
      echo "
set shell = CreateObject(\"WScript.Shell\")

comm = \"wsl nohup ${exec_command} &>/dev/null\"

shell.Run comm,0" > "${icon_prog_fold}/${program_keyname}.vbs"

      echo "
@echo off

set SCRIPT=\"%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs\"

echo Set oWS = WScript.CreateObject(\"WScript.Shell\") >> %SCRIPT%
echo sLinkFile = \"%SYSTEMDRIVE%\\${wdesk}\\${program_keyname}.lnk\" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = \"\\\\wsl.localhost\Debian\\${prog_fold}\\${program_keyname}.vbs\" >> %SCRIPT%
echo oLink.IconLocation = \"\\\\wsl.localhost\Debian\\${prog_fold}\\${program_keyname}_1.ico\" >> %SCRIPT%
echo oLink.WorkingDirectory = \"\\\\wsl.localhost\Debian\\${prog_fold}\\${program_keyname}_1.ico\" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%

cscript /nologo %SCRIPT%

del %SCRIPT%" >> "${wdesk})/short.bat"

  done
done
