<?php
 $result = passthru ('ssh -i key username@ip "/usr/bin/sudo /etc/init.d/nginx restart"');
 ?>
