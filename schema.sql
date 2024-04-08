
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE SCHEMA IF NOT EXISTS "public";

ALTER SCHEMA "public" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."ftc"("search" character varying) RETURNS TABLE("id" "text", "typ" "text", "bezeichnung" "text", "bereich" "text", "bereichs_bezeichnung" "text", "einzelplan" "text", "einzelplan_bezeichnung" "text", "kapitel" "text", "kapitel_bezeichnung" "text", "hauptgruppe" "text", "hauptgruppen_bezeichnung" "text", "obergruppe" "text", "obergruppen_bezeichnung" "text", "gruppe" "text", "gruppen_bezeichnung" "text", "hauptfunktion" "text", "hauptfunktions_bezeichnung" "text", "oberfunktion" "text", "oberfunktions_bezeichnung" "text", "funktion" "text", "funktions_bezeichnung" "text", "titel_art" "text", "titel" "text", "titel_bezeichnung" "text", "jahr" "text", "betrag_typ" "text", "betrag" "text")
    LANGUAGE "plpgsql"
    AS $$
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
$$;

ALTER FUNCTION "public"."ftc"("search" character varying) OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."haushaltsdaten_22_23" (
    "ID" "text",
    "Typ" "text",
    "Bezeichnung" "text",
    "Bereich" "text",
    "Bereichsbezeichnung" "text",
    "Einzelplan" "text",
    "Einzelplanbezeichnung" "text",
    "Kapitel" "text",
    "Kapitelbezeichnung" "text",
    "Hauptgruppe" "text",
    "Hauptgruppenbezeichnung" "text",
    "Obergruppe" "text",
    "Obergruppenbezeichnung" "text",
    "Gruppe" "text",
    "Gruppenbezeichnung" "text",
    "Hauptfunktion" "text",
    "Hauptfunktionsbezeichnung" "text",
    "Oberfunktion" "text",
    "Oberfunktionsbezeichnung" "text",
    "Funktion" "text",
    "Funktionsbezeichnung" "text",
    "Titelart" "text",
    "Titel" "text",
    "Titelbezeichnung" "text",
    "Jahr" "text",
    "BetragTyp" "text",
    "Betrag" "text"
);

ALTER TABLE "public"."haushaltsdaten_22_23" OWNER TO "postgres";

CREATE MATERIALIZED VIEW "public"."haushaltsdaten_2022" AS
 SELECT "haushaltsdaten_22_23"."ID" AS "id",
    "haushaltsdaten_22_23"."Typ" AS "typ",
    "haushaltsdaten_22_23"."Bezeichnung" AS "bezeichnung",
    "haushaltsdaten_22_23"."Bereich" AS "bereich",
    "haushaltsdaten_22_23"."Bereichsbezeichnung" AS "bereichs_bezeichnung",
    "haushaltsdaten_22_23"."Einzelplan" AS "einzelplan",
    "haushaltsdaten_22_23"."Einzelplanbezeichnung" AS "einzelplan_bezeichnung",
    "haushaltsdaten_22_23"."Kapitel" AS "kapitel",
    "haushaltsdaten_22_23"."Kapitelbezeichnung" AS "kapitel_bezeichnung",
    "haushaltsdaten_22_23"."Hauptgruppe" AS "hauptgruppe",
    "haushaltsdaten_22_23"."Hauptgruppenbezeichnung" AS "hauptgruppen_bezeichnung",
    "haushaltsdaten_22_23"."Obergruppe" AS "obergruppe",
    "haushaltsdaten_22_23"."Obergruppenbezeichnung" AS "obergruppen_bezeichnung",
    "haushaltsdaten_22_23"."Gruppe" AS "gruppe",
    "haushaltsdaten_22_23"."Gruppenbezeichnung" AS "gruppen_bezeichnung",
    "haushaltsdaten_22_23"."Hauptfunktion" AS "hauptfunktion",
    "haushaltsdaten_22_23"."Hauptfunktionsbezeichnung" AS "hauptfunktions_bezeichnung",
    "haushaltsdaten_22_23"."Oberfunktion" AS "oberfunktion",
    "haushaltsdaten_22_23"."Oberfunktionsbezeichnung" AS "oberfunktions_bezeichnung",
    "haushaltsdaten_22_23"."Funktion" AS "funktion",
    "haushaltsdaten_22_23"."Funktionsbezeichnung" AS "funktions_bezeichnung",
    "haushaltsdaten_22_23"."Titelart" AS "titel_art",
    "haushaltsdaten_22_23"."Titel" AS "titel",
    "haushaltsdaten_22_23"."Titelbezeichnung" AS "titel_bezeichnung",
    "haushaltsdaten_22_23"."Jahr" AS "jahr",
    "haushaltsdaten_22_23"."BetragTyp" AS "betrag_typ",
    "haushaltsdaten_22_23"."Betrag" AS "betrag",
    "to_tsvector"('"german"'::"regconfig", ((((((((((((((((((((((((((((((((((((((((((((((((((COALESCE("haushaltsdaten_22_23"."Typ", ''::"text") || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Bezeichnung", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Bereich", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Bereichsbezeichnung", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Einzelplan", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Einzelplanbezeichnung", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Kapitel", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Kapitelbezeichnung", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Hauptgruppe", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Hauptgruppenbezeichnung", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Obergruppe", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Obergruppenbezeichnung", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Gruppe", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Gruppenbezeichnung", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Hauptfunktion", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Hauptfunktionsbezeichnung", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Oberfunktion", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Oberfunktionsbezeichnung", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Funktion", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Funktionsbezeichnung", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Titelart", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Titel", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Titelbezeichnung", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Jahr", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."BetragTyp", ''::"text")) || ' '::"text") || COALESCE("haushaltsdaten_22_23"."Betrag", ''::"text"))) AS "search_document"
   FROM "public"."haushaltsdaten_22_23"
  WHERE ("haushaltsdaten_22_23"."Jahr" = '2022'::"text")
  WITH NO DATA;

ALTER TABLE "public"."haushaltsdaten_2022" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."nachtragshaushalt_opendata_22_23" (
    "ID" integer NOT NULL,
    "Typ" "text",
    "Bezeichnung" "text",
    "Bereich" "text",
    "Bereichsbezeichnung" "text",
    "Einzelplan" "text",
    "Einzelplanbezeichnung" "text",
    "Kapitel" "text",
    "Kapitelbezeichnung" "text",
    "Hauptgruppe" "text",
    "Hauptgruppenbezeichnung" "text",
    "Obergruppe" "text",
    "Obergruppenbezeichnung" "text",
    "Gruppe" "text",
    "Gruppenbezeichnung" "text",
    "Hauptfunktion" "text",
    "Hauptfunktionsbezeichnung" "text",
    "Oberfunktion" "text",
    "Oberfunktionsbezeichnung" "text",
    "Funktion" "text",
    "Funktionsbezeichnung" "text",
    "Titelart" "text",
    "Titel" "text",
    "Titelbezeichnung" "text",
    "Jahr" "text",
    "BetragTyp" "text",
    "Betrag" "text"
);

ALTER TABLE "public"."nachtragshaushalt_opendata_22_23" OWNER TO "postgres";

CREATE MATERIALIZED VIEW "public"."haushaltsdaten_current" AS
 SELECT "h"."ID" AS "id",
    "h"."Typ" AS "typ",
    "h"."Bezeichnung" AS "bezeichnung",
    "h"."Bereich" AS "bereich",
    "h"."Bereichsbezeichnung" AS "bereichs_bezeichnung",
    "h"."Einzelplan" AS "einzelplan",
    "h"."Einzelplanbezeichnung" AS "einzelplan_bezeichnung",
    "h"."Kapitel" AS "kapitel",
    "h"."Kapitelbezeichnung" AS "kapitel_bezeichnung",
    "h"."Hauptgruppe" AS "hauptgruppe",
    "h"."Hauptgruppenbezeichnung" AS "hauptgruppen_bezeichnung",
    "h"."Obergruppe" AS "obergruppe",
    "h"."Obergruppenbezeichnung" AS "obergruppen_bezeichnung",
    "h"."Gruppe" AS "gruppe",
    "h"."Gruppenbezeichnung" AS "gruppen_bezeichnung",
    "h"."Hauptfunktion" AS "hauptfunktion",
    "h"."Hauptfunktionsbezeichnung" AS "hauptfunktions_bezeichnung",
    "h"."Oberfunktion" AS "oberfunktion",
    "h"."Oberfunktionsbezeichnung" AS "oberfunktions_bezeichnung",
    "h"."Funktion" AS "funktion",
    "h"."Funktionsbezeichnung" AS "funktions_bezeichnung",
    "h"."Titelart" AS "titel_art",
    "h"."Titel" AS "titel",
    "h"."Titelbezeichnung" AS "titel_bezeichnung",
    "h"."Jahr" AS "jahr",
    "h"."BetragTyp" AS "betrag_typ",
    "h"."Betrag" AS "betrag",
    "to_tsvector"('"german"'::"regconfig", ((((((((((((((((((((((((((((((((((((((((((((((((((COALESCE("h"."Typ", ''::"text") || ' '::"text") || COALESCE("h"."Bezeichnung", ''::"text")) || ' '::"text") || COALESCE("h"."Bereich", ''::"text")) || ' '::"text") || COALESCE("h"."Bereichsbezeichnung", ''::"text")) || ' '::"text") || COALESCE("h"."Einzelplan", ''::"text")) || ' '::"text") || COALESCE("h"."Einzelplanbezeichnung", ''::"text")) || ' '::"text") || COALESCE("h"."Kapitel", ''::"text")) || ' '::"text") || COALESCE("h"."Kapitelbezeichnung", ''::"text")) || ' '::"text") || COALESCE("h"."Hauptgruppe", ''::"text")) || ' '::"text") || COALESCE("h"."Hauptgruppenbezeichnung", ''::"text")) || ' '::"text") || COALESCE("h"."Obergruppe", ''::"text")) || ' '::"text") || COALESCE("h"."Obergruppenbezeichnung", ''::"text")) || ' '::"text") || COALESCE("h"."Gruppe", ''::"text")) || ' '::"text") || COALESCE("h"."Gruppenbezeichnung", ''::"text")) || ' '::"text") || COALESCE("h"."Hauptfunktion", ''::"text")) || ' '::"text") || COALESCE("h"."Hauptfunktionsbezeichnung", ''::"text")) || ' '::"text") || COALESCE("h"."Oberfunktion", ''::"text")) || ' '::"text") || COALESCE("h"."Oberfunktionsbezeichnung", ''::"text")) || ' '::"text") || COALESCE("h"."Funktion", ''::"text")) || ' '::"text") || COALESCE("h"."Funktionsbezeichnung", ''::"text")) || ' '::"text") || COALESCE("h"."Titelart", ''::"text")) || ' '::"text") || COALESCE("h"."Titel", ''::"text")) || ' '::"text") || COALESCE("h"."Titelbezeichnung", ''::"text")) || ' '::"text") || COALESCE("h"."Jahr", ''::"text")) || ' '::"text") || COALESCE("h"."BetragTyp", ''::"text")) || ' '::"text") || COALESCE("h"."Betrag", ''::"text"))) AS "search_document"
   FROM "public"."nachtragshaushalt_opendata_22_23" "h"
  WITH NO DATA;

ALTER TABLE "public"."haushaltsdaten_current" OWNER TO "postgres";

ALTER TABLE "public"."nachtragshaushalt_opendata_22_23" ALTER COLUMN "ID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."nachtragshaushalt_opendata_22_23_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY "public"."nachtragshaushalt_opendata_22_23"
    ADD CONSTRAINT "nachtragshaushalt_opendata_22_23_pkey" PRIMARY KEY ("ID");

CREATE POLICY "Enable read access for all users" ON "public"."haushaltsdaten_22_23" FOR SELECT USING (true);

ALTER TABLE "public"."haushaltsdaten_22_23" ENABLE ROW LEVEL SECURITY;

REVOKE USAGE ON SCHEMA "public" FROM PUBLIC;
GRANT ALL ON SCHEMA "public" TO PUBLIC;
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON FUNCTION "public"."ftc"("search" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."ftc"("search" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."ftc"("search" character varying) TO "service_role";

GRANT ALL ON TABLE "public"."haushaltsdaten_22_23" TO "anon";
GRANT ALL ON TABLE "public"."haushaltsdaten_22_23" TO "authenticated";
GRANT ALL ON TABLE "public"."haushaltsdaten_22_23" TO "service_role";

GRANT ALL ON TABLE "public"."haushaltsdaten_2022" TO "anon";
GRANT ALL ON TABLE "public"."haushaltsdaten_2022" TO "authenticated";
GRANT ALL ON TABLE "public"."haushaltsdaten_2022" TO "service_role";

GRANT ALL ON TABLE "public"."nachtragshaushalt_opendata_22_23" TO "anon";
GRANT ALL ON TABLE "public"."nachtragshaushalt_opendata_22_23" TO "authenticated";
GRANT ALL ON TABLE "public"."nachtragshaushalt_opendata_22_23" TO "service_role";

GRANT ALL ON TABLE "public"."haushaltsdaten_current" TO "anon";
GRANT ALL ON TABLE "public"."haushaltsdaten_current" TO "authenticated";
GRANT ALL ON TABLE "public"."haushaltsdaten_current" TO "service_role";

GRANT ALL ON SEQUENCE "public"."nachtragshaushalt_opendata_22_23_ID_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."nachtragshaushalt_opendata_22_23_ID_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."nachtragshaushalt_opendata_22_23_ID_seq" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";

RESET ALL;
