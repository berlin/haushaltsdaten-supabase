drop materialized view if exists "public"."haushaltsdaten_current";

create table "public"."haushaltsdaten_2024_2025" (
    "Typ" text,
    "Bezeichnung" text,
    "Bereich" text,
    "Bereichsbezeichnung" text,
    "Einzelplan" text,
    "Einzelplanbezeichnung" text,
    "Kapitel" text,
    "Kapitelbezeichnung" text,
    "Hauptgruppe" text,
    "Hauptgruppenbezeichnung" text,
    "Obergruppe" text,
    "Obergruppenbezeichnung" text,
    "Gruppe" text,
    "Gruppenbezeichnung" text,
    "Hauptfunktion" text,
    "Hauptfunktionsbezeichnung" text,
    "Oberfunktion" text,
    "Oberfunktionsbezeichnung" text,
    "Funktion" text,
    "Funktionsbezeichnung" text,
    "Titelart" text,
    "Titel" text,
    "Titelbezeichnung" text,
    "Jahr" text,
    "BetragTyp" text,
    "Betrag" text,
    "ID" integer not null
);


CREATE UNIQUE INDEX haushaltsdaten_2024_2025_pkey ON public.haushaltsdaten_2024_2025 USING btree ("ID");

alter table "public"."haushaltsdaten_2024_2025" add constraint "haushaltsdaten_2024_2025_pkey" PRIMARY KEY using index "haushaltsdaten_2024_2025_pkey";

set check_function_bodies = off;

create materialized view "public"."haushaltsdaten_combined" as  SELECT nachtragshaushalt_opendata_22_23."Typ",
    nachtragshaushalt_opendata_22_23."Bezeichnung",
    nachtragshaushalt_opendata_22_23."Bereich",
    nachtragshaushalt_opendata_22_23."Bereichsbezeichnung",
    nachtragshaushalt_opendata_22_23."Einzelplan",
    nachtragshaushalt_opendata_22_23."Einzelplanbezeichnung",
    nachtragshaushalt_opendata_22_23."Kapitel",
    nachtragshaushalt_opendata_22_23."Kapitelbezeichnung",
    nachtragshaushalt_opendata_22_23."Hauptgruppe",
    nachtragshaushalt_opendata_22_23."Hauptgruppenbezeichnung",
    nachtragshaushalt_opendata_22_23."Obergruppe",
    nachtragshaushalt_opendata_22_23."Obergruppenbezeichnung",
    nachtragshaushalt_opendata_22_23."Gruppe",
    nachtragshaushalt_opendata_22_23."Gruppenbezeichnung",
    nachtragshaushalt_opendata_22_23."Hauptfunktion",
    nachtragshaushalt_opendata_22_23."Hauptfunktionsbezeichnung",
    nachtragshaushalt_opendata_22_23."Oberfunktion",
    nachtragshaushalt_opendata_22_23."Oberfunktionsbezeichnung",
    nachtragshaushalt_opendata_22_23."Funktion",
    nachtragshaushalt_opendata_22_23."Funktionsbezeichnung",
    nachtragshaushalt_opendata_22_23."Titelart",
    nachtragshaushalt_opendata_22_23."Titel",
    nachtragshaushalt_opendata_22_23."Titelbezeichnung",
    nachtragshaushalt_opendata_22_23."Jahr",
    nachtragshaushalt_opendata_22_23."BetragTyp",
    nachtragshaushalt_opendata_22_23."Betrag",
    nachtragshaushalt_opendata_22_23."ID"
   FROM nachtragshaushalt_opendata_22_23
UNION ALL
 SELECT haushaltsdaten_2024_2025."Typ",
    haushaltsdaten_2024_2025."Bezeichnung",
    haushaltsdaten_2024_2025."Bereich",
    haushaltsdaten_2024_2025."Bereichsbezeichnung",
    haushaltsdaten_2024_2025."Einzelplan",
    haushaltsdaten_2024_2025."Einzelplanbezeichnung",
    haushaltsdaten_2024_2025."Kapitel",
    haushaltsdaten_2024_2025."Kapitelbezeichnung",
    haushaltsdaten_2024_2025."Hauptgruppe",
    haushaltsdaten_2024_2025."Hauptgruppenbezeichnung",
    haushaltsdaten_2024_2025."Obergruppe",
    haushaltsdaten_2024_2025."Obergruppenbezeichnung",
    haushaltsdaten_2024_2025."Gruppe",
    haushaltsdaten_2024_2025."Gruppenbezeichnung",
    haushaltsdaten_2024_2025."Hauptfunktion",
    haushaltsdaten_2024_2025."Hauptfunktionsbezeichnung",
    haushaltsdaten_2024_2025."Oberfunktion",
    haushaltsdaten_2024_2025."Oberfunktionsbezeichnung",
    haushaltsdaten_2024_2025."Funktion",
    haushaltsdaten_2024_2025."Funktionsbezeichnung",
    haushaltsdaten_2024_2025."Titelart",
    haushaltsdaten_2024_2025."Titel",
    haushaltsdaten_2024_2025."Titelbezeichnung",
    haushaltsdaten_2024_2025."Jahr",
    haushaltsdaten_2024_2025."BetragTyp",
    haushaltsdaten_2024_2025."Betrag",
    haushaltsdaten_2024_2025."ID"
   FROM haushaltsdaten_2024_2025;


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
		haushaltsdaten_combined h
	WHERE
		search_document @@ plainto_tsquery('german', search);
END;
$function$
;

create materialized view "public"."haushaltsdaten_current" as  SELECT h."ID" AS id,
    h."Typ" AS typ,
    h."Bezeichnung" AS bezeichnung,
    h."Bereich" AS bereich,
    h."Bereichsbezeichnung" AS bereichs_bezeichnung,
    h."Einzelplan" AS einzelplan,
    h."Einzelplanbezeichnung" AS einzelplan_bezeichnung,
    h."Kapitel" AS kapitel,
    h."Kapitelbezeichnung" AS kapitel_bezeichnung,
    h."Hauptgruppe" AS hauptgruppe,
    h."Hauptgruppenbezeichnung" AS hauptgruppen_bezeichnung,
    h."Obergruppe" AS obergruppe,
    h."Obergruppenbezeichnung" AS obergruppen_bezeichnung,
    h."Gruppe" AS gruppe,
    h."Gruppenbezeichnung" AS gruppen_bezeichnung,
    h."Hauptfunktion" AS hauptfunktion,
    h."Hauptfunktionsbezeichnung" AS hauptfunktions_bezeichnung,
    h."Oberfunktion" AS oberfunktion,
    h."Oberfunktionsbezeichnung" AS oberfunktions_bezeichnung,
    h."Funktion" AS funktion,
    h."Funktionsbezeichnung" AS funktions_bezeichnung,
    h."Titelart" AS titel_art,
    h."Titel" AS titel,
    h."Titelbezeichnung" AS titel_bezeichnung,
    h."Jahr" AS jahr,
    h."BetragTyp" AS betrag_typ,
    h."Betrag" AS betrag,
    to_tsvector('german'::regconfig, ((((((((((((((((((((((((((((((((((((((((((((((((((COALESCE(h."Typ", ''::text) || ' '::text) || COALESCE(h."Bezeichnung", ''::text)) || ' '::text) || COALESCE(h."Bereich", ''::text)) || ' '::text) || COALESCE(h."Bereichsbezeichnung", ''::text)) || ' '::text) || COALESCE(h."Einzelplan", ''::text)) || ' '::text) || COALESCE(h."Einzelplanbezeichnung", ''::text)) || ' '::text) || COALESCE(h."Kapitel", ''::text)) || ' '::text) || COALESCE(h."Kapitelbezeichnung", ''::text)) || ' '::text) || COALESCE(h."Hauptgruppe", ''::text)) || ' '::text) || COALESCE(h."Hauptgruppenbezeichnung", ''::text)) || ' '::text) || COALESCE(h."Obergruppe", ''::text)) || ' '::text) || COALESCE(h."Obergruppenbezeichnung", ''::text)) || ' '::text) || COALESCE(h."Gruppe", ''::text)) || ' '::text) || COALESCE(h."Gruppenbezeichnung", ''::text)) || ' '::text) || COALESCE(h."Hauptfunktion", ''::text)) || ' '::text) || COALESCE(h."Hauptfunktionsbezeichnung", ''::text)) || ' '::text) || COALESCE(h."Oberfunktion", ''::text)) || ' '::text) || COALESCE(h."Oberfunktionsbezeichnung", ''::text)) || ' '::text) || COALESCE(h."Funktion", ''::text)) || ' '::text) || COALESCE(h."Funktionsbezeichnung", ''::text)) || ' '::text) || COALESCE(h."Titelart", ''::text)) || ' '::text) || COALESCE(h."Titel", ''::text)) || ' '::text) || COALESCE(h."Titelbezeichnung", ''::text)) || ' '::text) || COALESCE(h."Jahr", ''::text)) || ' '::text) || COALESCE(h."BetragTyp", ''::text)) || ' '::text) || COALESCE(h."Betrag", ''::text))) AS search_document
   FROM haushaltsdaten_combined h;


grant delete on table "public"."haushaltsdaten_2024_2025" to "anon";

grant insert on table "public"."haushaltsdaten_2024_2025" to "anon";

grant references on table "public"."haushaltsdaten_2024_2025" to "anon";

grant select on table "public"."haushaltsdaten_2024_2025" to "anon";

grant trigger on table "public"."haushaltsdaten_2024_2025" to "anon";

grant truncate on table "public"."haushaltsdaten_2024_2025" to "anon";

grant update on table "public"."haushaltsdaten_2024_2025" to "anon";

grant delete on table "public"."haushaltsdaten_2024_2025" to "authenticated";

grant insert on table "public"."haushaltsdaten_2024_2025" to "authenticated";

grant references on table "public"."haushaltsdaten_2024_2025" to "authenticated";

grant select on table "public"."haushaltsdaten_2024_2025" to "authenticated";

grant trigger on table "public"."haushaltsdaten_2024_2025" to "authenticated";

grant truncate on table "public"."haushaltsdaten_2024_2025" to "authenticated";

grant update on table "public"."haushaltsdaten_2024_2025" to "authenticated";

grant delete on table "public"."haushaltsdaten_2024_2025" to "service_role";

grant insert on table "public"."haushaltsdaten_2024_2025" to "service_role";

grant references on table "public"."haushaltsdaten_2024_2025" to "service_role";

grant select on table "public"."haushaltsdaten_2024_2025" to "service_role";

grant trigger on table "public"."haushaltsdaten_2024_2025" to "service_role";

grant truncate on table "public"."haushaltsdaten_2024_2025" to "service_role";

grant update on table "public"."haushaltsdaten_2024_2025" to "service_role";


