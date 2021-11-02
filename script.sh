subsys="$(echo $(uname -r) | rev | cut -d "-" -f1 | rev)"
declare wdesk="/mnt/c/Users/Axel F C/Desktop"
declare wsl2desk="/home/axl/Desktop"
declare ico_path="${wsl2desk}/git/icons/ico_images/"
desk=$(pwd)
if [ ${subsys} == "WSL2" ]; then
  echo "WSL2 Subsystem detected"
  programs_list="$(cd /home/axl/Desktop; ls -p | grep -v /)"
  for program in ${programs_list[@]}^; do
    name="$(echo ${program} | rev | cut -d "." -f2 | rev)"
    path="${desk}/${program}"
    COMM="$(echo "$(cat /home/axl/Desktop/*${name}.desktop | grep "Exec=")" | cut -d "=" -f2 | cut -d " " -f1 | uniq)"
    echo $COMM
    # We need a cleaner command... This might work, but need to be refined and possibly accept some arguments from Exec= line in .desktop file.
    echo "SEARCH ICON IN ico_images FOLDER STRUCTURE: "
    
    echo "Process correct name of CORRECT_PROGRAM_NAME_icon.ico image and save the image to safe path"
    echo "Create Command file (.vbs) containing right information about the image path and command"
    echo "Create shortcut in windows' desktop (written in short.bat from custom-wsl2-desktop)"
  done
else
  echo "We don't find any WSL2 Subsystem"
fi
read debug