OVERLAY='/data/resource-cache/overlays.list'
if [ -f "$OVERLAY" ]; then
  ui_print " "
  ui_print "   Removing $OVERLAY"
  rm -f "$OVERLAY"
  rm -rf /data/resource-cache
fi
