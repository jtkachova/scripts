<?php
$result = exec ('ssh -i key username@ip "/usr/bin/sudo /etc/init.d/uwsgi restart 2>&1"',$output);
$output_string = implode("\n", $output);
echo "$output_string";
 ?>
