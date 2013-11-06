<?php
function write2log($link)
{
 //$ip=$_SERVER['REMOTE_ADDR'];
 //$ua=$_SERVER['HTTP_USER_AGENT'];
 //$today = date("D M j G:i:s T Y");  
 $myFile = "/var/www/away.log";
 $fh = fopen($myFile, 'a+');
 $stringData = $link . "\n";
 echo $stringData;
 fwrite($fh, $stringData); 
 fclose($fh); 
}

if (isset($_GET['l'])) {
  $link = $_GET['l'];    
} else {
    $link = "index.php";   
}
write2log($link);
header( 'Location: http://www.mathnet.ru/'.$link);
?>

