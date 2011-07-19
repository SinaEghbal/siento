[vid, aviobj] = usbinit();
time=vidrec(vid);
usbclose(vid, aviobj);