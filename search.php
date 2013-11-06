<?php
function write2tmplog($text)
{
 //$ip=$_SERVER['REMOTE_ADDR'];
 //$ua=$_SERVER['HTTP_USER_AGENT'];
 //$today = date("D M j G:i:s T Y");  
 $myFile = "/var/www/search_i.log";
 $fh = fopen($myFile, 'a+');
 $stringData = $text . "\n";
 echo $stringData;
 fwrite($fh, $stringData); 
 fclose($fh); 
}
function showHeader()
{
	echo <<<END
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" 
   "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>
		Терминологический поиск по математическим статьям
	</title>
<meta http-equiv='Content-Type' content='application/xhtml+xml; charset=utf-8'/>
<link type="text/css" rel="stylesheet" href="/css/results.css" />
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
	 jax: ["input/TeX", "output/HTML-CSS"],
	showProcessingMessages: true,
  tex2jax: {inlineMath: [['$','$']],
  displayMath: [ ['$$','$$']],
  processEnvironments: false}
});
</script>
<script type="text/javascript"
   src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
</head>
<body>
END;
  echo "<div id=\"wrapper\">\n";
  showSideBar();
  echo "<div id=\"content1\">\n"; 
  require_once( 'request.php' );
}
/*
*/
function showFooter()
{
	require_once( 'footer.php' );
}

function showFullResponseSize($size)
{	
	$sd10=$size % 10;
	$sm10=($size-$sd10)/10;
	if ($sm10==1)
	{
	  echo "Найдено: ".$size." терминологических словосочетаний  \n";  
	} 
	else 
	{
	  if ($sd10==1)
	  {
		echo "Найдено: ".$size." терминологическое словосочетание  \n";  
	  } 
	  else 
	  {
		if (($sd10>1)&&($sd10<5))
		{
			echo "Найдено: ".$size." терминологических словосочетания  \n";  
		} 
		else 
		{
		  echo "Найдено: ".$size." терминологических словосочетаний  \n";  
		}
	  }
	}
}
//function generatequery($query2,$sort)
//{
	//if ($sort!="solr"){
		//$query3 = '+'.$query2.'+_val_:"'.$sort.'"^100';
    //} else {
		//$query3=$query2;
	//}		
    //return $query3;
//}
function generatesort($query2,$sort)
{
	//echo "<pre>$query2</pre>";
	$ar1= array("(", ")"," ");
	$ar2= array("AND", "OR");	
	$query3='sum(div('.$sort.',10),product(strdist(\''.str_replace($ar1,'',str_replace($ar2,'+',$query2)).'\',term,ngram),termlength)) desc';
	return $query3;
	//product(strdist('КВАДРАТИЧНЫЙ+ФУНКЦИЯ'%2Cterm%2Cngram),termlength)+desc
}
function showResponseSize($size)
{	
	$sd10=$size % 10;
	$sm10=($size-$sd10)/10;
	if ($sm10==1)
	{
		return $size." вхождений";  
	} else {
	if ($sd10==1)
	{
		return $size." вхождение";  
	} else {
		if (($sd10>1)&&($sd10<5))
		{
			return $size." вхождения";  
		} else {
			return $size." вхождений";  
		}
	}		}
}
function showFooterSearch()
{
	echo "<div id=\"clear\"></div>";
  echo "</div>";  //content1
   echo "<div id=\"footer-push\"></div>";
  echo "</div>"; //wrapper
}
function showSideBar()
{	
echo <<<END
 <div id="content" class="sidebar">
    <div id="sidebar">
    <div class="sidebarpic">
    <a href="http://kpfu.ru/"><img src="picture/kfu.jpg" width="200px" alt="Казанский (Приволжский) Федеральный Университет"/></a>
    </div>
    <div class="sidebarpic">  
    <a href="http://mathnet.ru/ivm"><img src="picture/ivm.jpg" width="200px" alt="Math-Net.Ru"/></a>
    </div>
    <div class="sidebarpic">
    <a href="http://www.ksu.ru/journals/izv_vuz/"><img src="picture/ivm2.jpg" width="200px" alt="Журнал &quot;Известия высших учебных заведений. Математика&quot;"/></a>
    </div>
    <div class="sidebarpic">
    <a href="http://cll.niimm.ksu.ru/"><img src="picture/cll.png" width="200px" alt="Лаборатория математической и компьютеной лингвистики"/></a>
    </div>
    </div>
    </div>
END;
}


function write2log($query,$query2,$offset)
{
 $ip=$_SERVER['REMOTE_ADDR'];
 $ua=$_SERVER['HTTP_USER_AGENT'];
 $today = date("D M j G:i:s T Y");  
 $myFile = "phprequest.log";
 $fh = fopen($myFile, 'a');
 $stringData = $ip . ' ' . $today . ' ' . $query . ' ' . $query2 . '&o=' . $offset . ' ' . $ua . "\n";
 //echo $stringData;
 fwrite($fh, $stringData); 
 fclose($fh); 
}
function showNavigation($dz,$offset,$limit,$query,$query2,$sort)
{
    #print_r($dz);
    echo "<div class=\"result_info\">\n";    
	$nextp=$offset+$limit;
    $prevp=$offset-$limit;
    if ($dz[2]) {
		  echo "  <a href=\"search.php?q=$query&amp;q2=$query2&amp;s=$sort&amp;o=$prevp\">&lt; Предыдущая </a>"; 
	  } 
	  else {
		  echo "  &lt; Предыдущая "; 
	  }
	 echo " Страница ". $dz[0];
    if ($dz[1]) {
		  echo "<a href=\"search.php?q=$query&amp;q2=$query2&amp;s=$sort&amp;o=$nextp\"> Следующая &gt;</a> \n";
	  }
	  else {
		  echo " Следующая &gt;\n";
	  }	
	  echo "  <div class=\"clear\"></div>\n";
	echo "</div>\n";
}
function navigation($solr,$query3,$offset,$limit, $params)
{
	  //echo "$offset1,$numfound1";
      $dz[0]=(integer)($offset/$limit)+1;  
      $nextp=$offset+$limit;
      $prevp=$offset-$limit;
      #echo "<br><br>";
      try {
        $response=$solr->search( $query3, $nextp, $limit, $params);
        #print_r($response->grouped->link);
        if ($response->getHttpStatus() == 200 )
          {$dz[1]=(isset($response->grouped->link->groups[0]));}
          else {$dz[1]=0;}
      }
      catch (Exception $e) {
        #echo $e;
        $dz[1]=0;
      }
      try {
        $response=$solr->search( $query3, $prevp, $limit, $params);
        if ($response->getHttpStatus() == 200 )
          {$dz[2]=(isset($response->grouped->link->groups[0]));}
          else {$dz[2]=0;}
	  }
	  catch (Exception $e) {
		$dz[2]=0;
        #echo $e;
      }
      return $dz;
}
//2,2385
//27,394
function showOtherSE($query,$output2)
{
			echo " <div id=\"result_list\">\n";
			echo "<div class=\"result\">\n";	
			echo "<pre>$output2[1]</pre>\n";
			echo "</div>\n";
			echo "<div class=\"result\">\n";	
			echo "<a href=\"http://yandex.ru/yandsearch?site=mathnet.ru&amp;text=".str_replace(' ','+',$query)."\">Воспользоваться поиском Яндекс</a>\n";
			echo "</div>\n";
			echo "<div class=\"result\">\n";	
			echo "<a href=\"http://google.ru/?q=site:mathnet.ru+".str_replace(' ','+',$query)."\">Воспользоваться поиском Google</a>\n";
			echo "</div>\n";
			echo "<div class=\"result\">\n";	
			echo "<a href=\"http://citeseerx.ist.psu.edu/search?q=".str_replace(' ','+',$query)."\">Воспользоваться поиском CiteSeerX</a>\n";
			echo "</div>\n";
			echo "</div>\n";
}

function morphsh($mquery)
{
	$query=str_replace('\'','',$mquery);
    $cmd1='bash searchsh/morph_s.sh \''.$query.'\'';
    //echo $cmd1;
    $output = shell_exec($cmd1);   
	  return $output;
}  









  require_once( 'Apache/Solr/Service.php' );
  $solr = new Apache_Solr_Service( 'localhost', '8983', '/solr' );
  if (isset($_GET['q'])){
    $query=$_GET['q'];
  }else{
    $query = "";
  }
  if (isset($_GET['o'])){
    $offset=$_GET['o'];
    if ($offset==""){
      $offset=0;
    }
  }else{
    $offset = 0;
  }
  if (isset($_GET['s'])){
    $sort=$_GET['s'];
    if ($sort==""){
      $sort='pagerank';
    }
  }else{
    $sort='pagerank';
  }  
  if (isset($_GET['q2'])){
	$query2=$_GET['q2'];
  }else{
    $query2="";
  }
  if (isset($_GET['r'])){
    $retry=$_GET['r'];
  }else{
	  $retry=0;
  } 
  if ( ! $solr->ping()){
	if ($retry>5){
			showHeader();
	        echo "<pre>Solr service not responding.</pre>";
	        showFooterSearch();
            showFooter();
            exit;
	}else{
		    sleep(2);
		    //write2tmplog("Ssnr: r=".($retry+1)."&amp;q=".str_replace(' ','+',$query)."&amp;s=".$sort);
			header("Location: search.php?r=".($retry+1)."&q=".str_replace(' ','+',$query)."&s=".$sort);
			exit;
	}
  }
  if ($query2=="")
  {
	  $output=morphsh($query);	
      if ($output!=NULL)
      {
		//echo "<pre>$output</pre>";
		$output2=explode("\n",$output);		
		if ($output2[0]=='0')
		{
			$query2=$output2[1];
			$query3s = generatesort($query2,$sort);
		}
		else 
		{
		  if ((($output2[0]=='1')&&($retry>1))||(($output2[0]=='2')&&($retry>5)))
		  {
			showHeader();
            showOtherSE($query,$output2);
			$query2="";
			$query3s="";
			showFooterSearch();
            showFooter();
            exit;
		  }	
		  else
		  {
			  //write2tmplog("msh: r=".($retry+1)."&amp;q=".str_replace(' ','+',$query)."&amp;s=".$sort);
			  header( "Location: search.php?r=".($retry+1)."&q=".str_replace(' ','+',$query)."&s=".$sort);
			  exit;
		  }
		}
	}
	else 
	{
		if ($retry>2)
		{
			showHeader();
	        echo "<pre>BASH ERROR</pre>";
	        showFooterSearch();
            showFooter();
            exit;
	    }
	    else
	    {
			//write2tmplog("BE: r=".($retry+1)."&amp;q=".str_replace(' ','+',$query)."&amp;s=".$sort);
			header( "Location: search.php?r=".($retry+1)."&amp;q=".str_replace(' ','+',$query)."&amp;s=".$sort);
			exit;
		}
	}
  }
  else 
  {
	  $query3s = generatesort($query2,$sort);
  }
  showHeader();
  if ($query3s != "")
  {
  write2log($query,$query3s,$offset);
  $params['group']='true';
  $params['sort']=$query3s;
  $params['group.field']='link';
  $params['hl']='true';
  $params['hl.fl']='preview';
  $params['hl.fragsize']='50000';
  #$params['group.limit']='1';
  #$params['group.format']='simple';
  $limit=10;
  #echo "<pre>$query2</pre>";
  $response = $solr->search( $query2, $offset, $limit, $params);
  //echo "<pre>$response</pre>"
  if ( $response->getHttpStatus() == 200 ) { 	
	  echo "<div>\n";
      echo "Результаты поиска по запросу: ".$query2." <br/>\n";      
      showFullResponseSize($response->grouped->link->matches); 
      echo "</div>\n";
/*
      echo "<div><pre>";
      print_r($response->highlighting);
      echo "</pre></div>";
*/      
      if ( $response->grouped->link->matches > 0 ) {
		$nav=navigation($solr,$query2,$offset,$limit, $params);
		showNavigation($nav,$offset,$limit,$query,$query2,$sort);
		echo "<div id=\"result_list\">\n";
		$inum=$offset;
        foreach ( $response->grouped->link->groups as $group ) { 
	      $inum++;
		  #print_r( $group->doclist->docs[0]->preview[0]);
		  echo "  <div class=\"result\"><h3>\n";
          echo "    ".$inum.". <a href=\"" . $group->groupValue . "\">" . htmlspecialchars($group->doclist->docs[0]->title) . "</a></h3> \n";
          echo "    <div class=\"pubinfo\">\n";
          echo "      ".$group->doclist->docs[0]->author."\n";
          echo "      ".$group->doclist->docs[0]->year . ", " . showResponseSize($group->doclist->numFound)."\n";
          echo "    </div>\n";
          echo "    <div class=\"pubinfo\">\n";
          echo "      УДК: " . $group->doclist->docs[0]->udk."\n";
          echo "    </div>\n";
          echo "    <div class=\"snippet\">\n";
          $docid=$group->doclist->docs[0]->id;
          #if ()
          #echo "<div><pre>";
          if (isset($response->highlighting->$docid->preview[0])){
			 echo "      ".str_replace(array('&lt;em&gt;','&lt;/em&gt;'),array('<em>','</em>'),htmlspecialchars($response->highlighting->$docid->preview[0]))."\n"; 
		  }else {
		      #echo "</pre></div>"; 
              echo "      ".htmlspecialchars($group->doclist->docs[0]->preview[0])."\n" ;
			}
          echo "    </div>\n";
          echo "  </div>\n";
        }
        echo "</div>\n";//result_list<em> </em>
        showNavigation($nav,$offset,$limit,$query,$query2,$sort);
    }
  }
  else {
    echo $response->getHttpStatusMessage();
  }} 
  showFooterSearch();
  showFooter();
?>
