set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.ftc(search character varying)
 RETURNS TABLE(id text, typ text, bezeichnung text, bereich text, bereichs_bezeichnung text, einzelplan text, einzelplan_bezeichnung text, kapitel text, kapitel_bezeichnung text, hauptgruppe text, hauptgruppen_bezeichnung text, obergruppe text, obergruppen_bezeichnung text, gruppe text, gruppen_bezeichnung text, hauptfunktion text, hauptfunktions_bezeichnung text, oberfunktion text, oberfunktions_bezeichnung text, funktion text, funktions_bezeichnung text, titel_art text, titel text, titel_bezeichnung text, jahr text, betrag_typ text, betrag text)
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN query
	SELECT
		h.id::text,
		h.typ,
		h.bezeichnung,
		h.bereich,
		h.bereichs_bezeichnung,
		h.einzelplan,
		h.einzelplan_bezeichnung,
		h.kapitel,
		h.kapitel_bezeichnung,
		h.hauptgruppe,
		h.hauptgruppen_bezeichnung,
		h.obergruppe,
		h.obergruppen_bezeichnung,
		h.gruppe,
		h.gruppen_bezeichnung,
		h.hauptfunktion,
		h.hauptfunktions_bezeichnung,
		h.oberfunktion,
		h.oberfunktions_bezeichnung,
		h.funktion,
		h.funktions_bezeichnung,
		h.titel_art,
		h.titel,
		h.titel_bezeichnung,
		h.jahr,
		h.betrag_typ,
		h.betrag
	FROM
		haushaltsdaten_current h
	WHERE
		search_document @@ plainto_tsquery('german', search);
END;
$function$
;


