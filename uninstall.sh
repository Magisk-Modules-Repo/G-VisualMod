rm -rf /data/adb/gvisualmod
rm -rf /data/resource-cache/overlays.list
find /data/resource-cache/ -type f \( -name "*Gestural*" -o -name "*Gesture*" -o -name "*GUI*" -o -name "*GPill*" -o -name "*GStatus*" \) \
	-exec rm -rf {} \;

