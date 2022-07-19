CREATE INDEX ON haushaltsdaten_2022 USING gin (search_document);

SELECT
	*
FROM
	haushaltsdaten_2022
WHERE
