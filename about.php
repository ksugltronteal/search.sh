<?php
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
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
<link type="text/css" rel="stylesheet" href="/css/results.css" />
</head>
<body>
END;
  
}

function showDescription()
{
echo <<<END
<div id="desc">
<p>
  Терминологический поиск по математическим статьям - это попытка реализации некоторой промежуточной формы поиска по ключевым словам между простым поиском документов, содержащих искомые ключевые слова, и поиском точных форм. 
</p>
<p>
  Используется дополнительная семантическая информация заключающаяся в терминологии пердметной области (в данном случае - математики).
</p>
<p>
  Автоматически извлекаются терминологические словосочетания после чего поиск ведётся уже только внутри рамок этих терминологических словосочетаний. Поэтому запросы "задача Коши" и "квадратичная функция" будут обрабатываться, а "автор" и "предположение" - нет.
</p>
<p>
  На запрос возвращаются статьи, в которых есть термин, содержащий все слова (вне зависимости от их морфологической формы) пользовательского запроса.
</p>
<p>
  Ранжирование результатов производится по метрике <a href="http://www.cs.ualberta.ca/~kondrak/papers/spire05.pdf">ngram distance</a> между запросной фразой и соответствующим термином. Так как в результаты уже отобраны только те термины, которые содержат все запросные слова, то метрика оценивает порядок слов и их количество.
</p>
<p>
  Кроме того ранжирование осуществляется на основе межстатейных ссылок. Пользователь может выбирать из метрик:
</p>
  <ul>
  <li><a href="http://ru.wikipedia.org/wiki/PageRank">PageRank</a></li>
  <li><a href="http://en.wikipedia.org/wiki/HITS_algorithm">Hub</a></li>
  <li><a href="http://en.wikipedia.org/wiki/HITS_algorithm">Authoruty</a></li>
  </ul>

<p>
Поисковая система содержит в своём индексе 1456 статей журнала <a href="http://old.kpfu.ru/journals/izv_vuz/">"Известия высших учебных заведений. Математика"</a> за 1997-2009 года, исчерпывающие метаданные этих статей, а также библиографические ссылки между ними.
</p>


</div>
END;
}

showHeader();
echo '<div id="wrapper">';
echo '<div id="wrapper2">';
require_once( 'request.php' );
showDescription();
echo '</div>';
echo '</div>';
require_once( 'footer.php' );
?>
