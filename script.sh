subsys="$(echo $(uname -r) | rev | cut -d "-" -f1 | rev)"
declare wdesk="/mnt/c/Users/Axel F C/Desktop"
declare wsl2desk="/home/axl/Desktop"
declare ico_path="${wsl2desk}/git/icons/ico_images/"
desk=$(pwd)

if [ ${subsys} == "WSL2" ]; then
  echo "WSL2 Subsystem detected"

  # We cannot launch nemo, because the folder it's not Nemo, it's Nemo_Desktop...
  if [ -f /home/axl/Desktop/git/icons/ico_images/root/Nemo_Desktop ]; then
    mv /home/axl/Desktop/git/icons/ico_images/root/Nemo_Desktop /home/axl/Desktop/git/icons/ico_images/root/Nemo
  fi

  programs_list="$(cd /home/axl/Desktop; ls -p | grep -v /)"
  for program in ${programs_list[@]}^; do
    name="$(echo ${program} | rev | cut -d "." -f2- | rev)"
    path="${desk}/${program}"
    COMM="$(echo "$(cat /home/axl/Desktop/*${name}.desktop | grep "Exec=")" | cut -d "=" -f2 | cut -d " " -f1 | uniq )"
    echo $COMM
    # We need a cleaner command... This might work, but need to be refined and possibly accept some arguments from Exec= line in .desktop file.
    
    # "SEARCH MATCHING ICON IN ico_images FOLDER STRUCTURE: "
    cd ${ico_path}
    folderss="$(ls)"
    for folder in "${folderss}"; do
        rootfolder="$(echo "${folder}" | tr '\n' ' ' | cut -d " " -f1)"
        userfolder="$(echo "${folder}" | tr '\n' ' ' | cut -d " " -f2)"
        cd "${rootfolder}"
        for folders in "$(ls)"; do
          #lowercase_root="${folders,,}"
          for prog_fold in ${folders[@]}; do
            COMM2="$(echo ${COMM} | tr '-' '_')"
            COMM3="$(echo "${prog_fold,,}" | cut -d "_" -f1- | tr '.' ' ')"
            
            if [ "${COMM2}" == "${COMM3}" ]; then

              #echo "${COMM3}"
              cd "$(pwd)/${prog_fold}"
              #echo "${prog_fold}_icon.ico"
              icon_path="$(echo "$(pwd)/$(echo ${prog_fold}_icon.ico)")"
              #echo "Create Command file (.vbs) containing right information about the image path and command"

              #echo "${vbsfile}"
              echo "
set shell = CreateObject(\"WScript.Shell\")

comm = \"wsl nohup ${COMM} &>/dev/null\"

shell.Run comm,0" > "$(pwd)/${COMM}.vbs"

              echo "
@echo off

set SCRIPT=\"%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs\"

echo Set oWS = WScript.CreateObject(\"WScript.Shell\") >> %SCRIPT%
echo sLinkFile = \"%SYSTEMDRIVE%\Users\Axel F C\Desktop\\${prog_fold}.lnk\" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = \"\\\\wsl.localhost\Debian\home\axl\Desktop\git\icons\ico_images\root\\${prog_fold}\\${COMM}.vbs\" >> %SCRIPT%
echo oLink.IconLocation = \"\\\\wsl.localhost\Debian\home\axl\Desktop\git\icons\ico_images\root\\${prog_fold}\\${prog_fold}_icon.ico\" >> %SCRIPT%
echo oLink.WorkingDirectory = \"\\\\wsl.localhost\Debian\home\axl\Desktop\git\icons\ico_images\root\\${prog_fold}\\${prog_fold}_icon.ico\" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%

cscript /nologo %SCRIPT%

del %SCRIPT%" > "$(pwd)/short.bat"
              #hola >> "$(pwd)/${COMM}.vbs"
              cd ..
            else
              :
              #echo "error?"
            fi
          done
          
        done
        cd ..
        #cd "${userfolder}"
        #for folders in "$(ls)"; do
          #echo "${folders,,}"
        #done
        #cd ..
    done
        
    #echo "Create shortcut in windows desktop (written in short.bat from custom-wsl2-desktop)"
  done
else
  echo "We don't find any WSL2 Subsystem"
fi
read debug