<?php
while (true) {
    $smg = sprintf("------ %s ------\n", time());
    $file = 'cli.log';
    file_put_contents($file, $smg, FILE_APPEND | LOCK_EX);
    sleep(5);
}
