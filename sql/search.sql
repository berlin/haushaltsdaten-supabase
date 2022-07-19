SELECT
	*
FROM
	haushaltsdaten_2022
WHERE
	"document" @@ phraseto_tsquery('german', 'Brücke über die Panke');

SELECT
	*
FROM
	haushaltsdaten_2022
WHERE
	"search_document" @@ plainto_tsquery('german', 'Brücke  die Panke');

SELECT
	*
FROM
	haushaltsdaten_2022
WHERE
	"document" @@ to_tsquery('german', 'Brücke & über & die & Panke');

