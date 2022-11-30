drop materialized view if exists "public"."haushaltsdaten_current";

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
   FROM nachtragshaushalt_opendata_22_23 h;



