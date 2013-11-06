<?php
function buildSelect( $ar=array(), $sel=null ) {
  $out = array();
  foreach($ar as $v) 
      $out[] = "<option value=\"".strtolower($v)."\"".(($sel==strtolower($v))? ' selected="selected"':'') . ">$v</option>";
return " <select name=\"s\">" . implode('', $out) . "</select>";
}
//<div align="center" >
echo <<<END
<div class="query_string">
<a href="index.php">
<img src="picture/ksu_logo.gif" width="30%" alt="Казанский (Приволжский) Федеральный Университет"/>
</a><br/>
ТЕРМИНОЛОГИЧЕСКИЙ ПОИСК ПО МАТЕМАТИЧЕСКИМ СТАТЬЯМ <br />
Журнал "Известия высших учебных заведений. Математика"
END;
if (isset($_GET['q'])) {
    $q1 = $_GET['q'];
} else {
    $q1 = "";
}
if (isset($_GET['s'])) {
    $q2 = $_GET['s'];
    if ($q2=="") {
	$q2 = "pagerank";
}
} else {
    $q2 = "pagerank";
}
echo <<<END
<form action="search.php" method="get">
 <p> <input type="text" name="q" size="64" value="$q1"/>
<input type="submit" value="Поиск"/>
sort by:
END;
$contacts = array('PageRank','Hub','Authority');
echo buildSelect( $contacts, $q2);
echo '</p>';
echo '</form>';
echo "</div>";
?>
