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
    # We need a cleaner command... This might work, but neet to be refined and possibly accept the arguments from Exec= in .desktop file.
    echo "SEARCH ICON: "
    echo "Process NAME_PROGRAM.ico image"
    echo "Create Command file"
    echo "Create shortcut in windows (written in short.bat from custom-wsl2-desktop)"
  done
else
  echo "We don't find any WSL2 Subsystem"
fi
read debug