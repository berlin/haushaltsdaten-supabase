CREATE TABLE "public"."nachtragshaushalt_opendata_22_23" (
	"ID" integer GENERATED BY DEFAULT AS IDENTITY NOT NULL,
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
	"Betrag" text
);

CREATE UNIQUE INDEX "nachtragshaushalt_opendata_22_23_pkey" ON public."nachtragshaushalt_opendata_22_23" USING btree ("ID");

ALTER TABLE "public"."nachtragshaushalt_opendata_22_23"
	ADD CONSTRAINT "nachtragshaushalt_opendata_22_23_pkey" PRIMARY KEY USING INDEX "nachtragshaushalt_opendata_22_23_pkey";

