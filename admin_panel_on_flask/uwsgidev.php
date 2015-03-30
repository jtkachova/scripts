<?php
$result = passthru ('ssh -i key user@ip "/usr/bin/sudo /etc/init.d/uwsgi restart 2>&1"'); 
$output_string = implode("\n", $output);
echo "$output_string";
?>
