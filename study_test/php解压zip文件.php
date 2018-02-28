<?php
/**********************
*@file - path to zip file 需要解压的文件的路径
*@destination - destination directory for unzipped files 解压之后存放的路径
*@需要使用 ZZIPlib library ，请确认该扩展已经开启
*/ 


function unzip_file($file, $destination, $pwd){ 
    // 实例化对象 
    $zip = new ZipArchive() ; 
    //打开zip文档，如果打开失败返回提示信息 
    if ($zip->open($file) !== true) { 
      die ("fail to open"); 
    } 

    $zip->setPassword($pwd);
    //将压缩文件解压到指定的目录下 
    $res = $zip->extractTo($destination);
    //关闭zip文档 
    $zip->close(); 

    if (!$res) {
        # code...
        echo "fail to extract";
        $extract_file = $destination.'\lock_username.txt';
        if (file_exists($extract_file)) {
            # code...
            unlink($extract_file);
        }
        rmdir($destination);
        return 0;
    }
    echo 'success'; 
    return 1;
} 
//测试执行 

$file = "C:\Users\Administrator\Desktop\lock_username.zip";
$path = "jieya";
//unzip_file($file, $path, $pwd); 
$fh = fopen('C:\Users\Administrator\Desktop\10_million_password_list_top_100.txt', 'r');
$status = false;
while (($pwd = fgets($fh, 4096)) !== false) {
    $pwd = trim($pwd);
    $res = unzip_file($file, $path, $pwd); 
    echo PHP_EOL;
    if ($res == 1) {
        # code...
        $status = true;
        echo 'password is '.$pwd;
        break;
    }
}

if (!$status) {
    echo PHP_EOL;
    echo "sorry, I coundon to extract the file";
    echo PHP_EOL;
}
?>