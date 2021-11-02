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
              icon_path="$(echo "$(pwd)/$(echo ${prog_fold})")"
              
              echo "${COMM}_icon=${icon_path}"
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
    
    #echo "Process correct name of CORRECT_PROGRAM_NAME_icon.ico image and save the image to safe path"
    #echo "Create Command file (.vbs) containing right information about the image path and command"
    #echo "Create shortcut in windows desktop (written in short.bat from custom-wsl2-desktop)"
  done
else
  echo "We don't find any WSL2 Subsystem"
fi
read debug