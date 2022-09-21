<?php
$out = '';
exec("git branch", $r);
foreach ($r as $b) {   
    if (strpos($b, '*') !== false) {
        $out = ltrim($b, "* ");
    }
}
echo $out;