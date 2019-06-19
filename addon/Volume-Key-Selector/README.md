# Volume Key Selector - Addon that allows the use of the volume keys to select option in the installer

## Instructions:
* If you only want vol keys to run during install or uninstall, rename the main.sh file to preinstall.sh or uninstall.sh respectively
* Use $VKSEL variable whenever you want to call the volume key selection function. The function returns true if user selected vol up and false if vol down
Ex: if $VKSEL; then
      echo "true"
    else
      echo "false"
    fi
* If you want to use the bixby button on samsung galaxy devices, [check out this post here](https://forum.xda-developers.com/showpost.php?p=77908805&postcount=16) and modify the main.sh functions accordingly
* If a user knows their device isn't compatible, they can skip this completely by adding "novk" to the zipname so make sure you have defaults set in the event this happens (you can use something like [ -z $VKSEL ])
    
## Included Binaries/Credits:
* [keycheck binary](https://github.com/sonyxperiadev/device-sony-common-init/tree/master/keycheck) compiled by me [here](https://github.com/Zackptg5/Keycheck)
