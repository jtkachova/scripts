<?php
 $result = passthru ('ssh -i key user@ip "/usr/bin/sudo /etc/init.d/nginx restart"');
 ?>
