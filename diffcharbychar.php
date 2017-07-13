<?php

$width = 80;

$file1 = file_get_contents($argv[1]);
$file2 = file_get_contents($argv[2]);

$lines = [];
$line = 0;

$diff = false;
$prev = false;
for ($i = 0; $i < max(strlen($file1), strlen($file2)); $i++) {
	$prev = $diff;
	$diff = !isset($file1[$i]) || !isset($file2[$i]) || $file1[$i] !== $file2[$i];
	
	if ($diff && !$prev) {
		$lines[$line][] = "[[ ";
		$lines[$line + 1][] = "[[ ";
	} else if (!$diff && $prev) {
		$lines[$line][] = " ]]";
		$lines[$line + 1][] = " ]]";
	}

	$lines[$line][] = isset($file1[$i]) ? $file1[$i] : " ";
	$lines[$line + 1][] = isset($file2[$i]) ? $file2[$i] : " ";

	if ($i && $i % 80 === 0) {
		$line += 2;
		$lines[$line] = [];
		$lines[$line + 1] = [];
	}
}

echo implode("\n", array_map(function($line) { return implode("", $line); }, $lines));
