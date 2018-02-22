<?php

//生成 00000-99999 的txt文本
function createNumber(){
	for ($i=0; $i < 9999; $i++) { 

		$len = strlen($i);
		if ($len<6) {
			# code...
			$bbb = str_repeat(0, (4-$len)).$i;
		}
		$data = $bbb."\r\n";
		file_put_contents('./my.txt', $data, FILE_APPEND);

		// if ($i>10) {
		// 	# code...
		// 	// break;
		// }
	}
}

 createNumber();