# Syntax for mounts
#
# rmount["mount point inside kali (from /)"]="path in android"
# mount["mount point inside kali (from /)"]="path in android:filesystem type"
#
# NOTE: filesystem type can be left empty

# The rmount array is mounted with --rbind

# Do not remove these
rmount["sys"]="/sys"
rmount["proc"]="/proc"
rmount["dev"]="/dev"

#rmount["system"]="/system"
#rmount["sdcard"]="/sdcard"

# The mount array is mounted normally

mount["tmp"]="tmpfs:tmpfs"
