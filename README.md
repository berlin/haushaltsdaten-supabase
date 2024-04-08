![](https://img.shields.io/badge/Built%20with%20%E2%9D%A4%EF%B8%8F-at%20Technologiestiftung%20Berlin-blue)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

# Haushaltsdaten Supabase Backend

Small supabase setup for [haushaltsdaten visualization project](https://haushaltsdaten.odis-berlin.de/) by [ODIS](https://odis-berlin.de/). See the frontend repo [here](https://github.com/berlin/haushaltsdaten)

## Prerequisites

- [Docker](https://docker.com)
- [Supabase](https://supabase.com) Account
- A Supabase project to work with
- The [Supabase CLI](https://github.com/supabase/cli)
- "Haushaltsdaten" data from https://daten.berlin.de/datensaetze/ exported as CSV (2022/23 is provided in this repo)
  - Use Excel File > Save As > CSV
- [Deno](https://deno.land/) for debugging edge functions only

If you don't feel comfortable with having your data stored on supabase.com (which uses AWS) you can run your own supabase setup. See the [guides on self hosting](https://supabase.com/docs/guides/hosting/overview) and the [docker examples](https://github.com/supabase/supabase/tree/master/docker) in their public repo.

## Installation

_(The following steps assume you are using the hosted version of supabase)_ To install this project, run the following command:

```bash
git clone git@github.com:berlin/haushaltsdaten-supabase.git
cd haushaltsdaten-supabase
supabase start
supabase link --project-ref <YOUR PROJECT REF>
supabase db remote set <YOUR DB URL>
supabase db push
```

You will need use some kind of tool like TablePlus, Postico or PGAdmin to populate the db with data from. If you are not familiar with Postgres Databases use TablePlus. It has the easiest interface.

For your local database instance you can use the following credentials:

- User: `postgres`
- Password: `postgres`
- Database: `postgres`

On the remote database the password was set by you when you created the project.

You will have to import the data only in the remote DB. If you want to try things out first or you want to make changes to the schema use the local instance.

---

**Hint!:** **When importing the data into the table `haushaltsdaten_22_23` Make sure to use `;` as delimiter.**

![](./docs/tableplus-import.png)

---

When your data is imported you need to refresh the materialized view. Run this query in your database tool.

```sql
REFRESH MATERIALIZED VIEW haushaltsdaten_current;
```

## Update the Data

Once a new "Haushaltsplan" is published you will have to:

- Import the data into a new table locally
- Add an ID column to the new table
- Update the materialized view query for the table `haushaltsdaten_current` to point at that new data
- If you want to display all years available years create the materialized view `haushaltsdaten_combined`
- Refresh the materialized view

### Import the data

There is currently no script availalbe to automate this step. You will have to clean and import the data manually. We encoutered the following issues:

- Data not in UTF8 (to check the encoding use [scripts/check-encoding.js](scripts/check-encoding.js) to convert the encoding use [scripts/convert-encoding.js](scripts/convert-encoding.js))
- Data has no headers. We copied them over manually

Therefore you will need to clean your data before import.

### Add an ID column

To add the ID colmn to your new table use this snippet.

```sql
BEGIN;
-- start the transaction
-- Attempt to perform the operation

DO $$
	-- start an anonymous block
BEGIN
	CREATE SEQUENCE tmp_id
;
	-- Creates a new sequence named 'tmp_id' for incremental value generation.
	ALTER TABLE haushaltsdaten_2024_2025
		ADD COLUMN "ID" int4;
	-- Modifies the structure of the table 'haushaltsdaten_2024_2025' by adding a new column 'ID' of type integer.
	ALTER TABLE haushaltsdaten_2024_2025
		ADD PRIMARY KEY ("ID");
	-- Modifies the table 'haushaltsdaten_2024_2025' by setting the 'ID' column as the primary key.
	UPDATE
		haushaltsdaten_2024_2025
	SET
		"ID" = nextval('tmp_id');
	-- Updates the 'ID' column of the table with the next value from the sequence 'tmp_id'.
	SELECT
		*
	FROM
		haushaltsdaten_2024_2025
	ORDER BY
		"ID";
	-- Retrieves all the data from the table 'haushaltsdaten_2024_2025' and orders it based on the 'ID' column.
	DROP SEQUENCE tmp_id
;
	-- Removes the sequence 'tmp_id' from the database system.
EXCEPTION -- A block that executes if an exception occurs in the above block
WHEN OTHERS THEN
	RAISE NOTICE 'An error has occured. Changes are being rolled back.';
ROLLBACK;
-- ends the current transaction and rolls back any changes that were made
END
$$;
-- end the anonymous block
COMMIT;

-- if all operations were successful, end the transaction with changes
```

### Update the materialized view hausahltsdaten_current

The `FROM` clause will have to point to your current data, if all years should be displayed you will have to create a new materialized view `haushaltsdaten_combined` and point to that.


```sql
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
   FROM haushaltsdaten_combined h;
REFRESH MATERIALIZED VIEW haushaltsdaten_current;
```

### combine all years into one table

To have all years available we create a materialized view that combines all years into one table called `haushaltsdaten_combined`.

```sql
CREATE MATERIALIZED VIEW haushaltsdaten_combined AS
SELECT
    "Typ",
    "Bezeichnung",
    "Bereich",
    "Bereichsbezeichnung",
    "Einzelplan",
    "Einzelplanbezeichnung",
    "Kapitel",
    "Kapitelbezeichnung",
    "Hauptgruppe",
    "Hauptgruppenbezeichnung",
    "Obergruppe",
    "Obergruppenbezeichnung",
    "Gruppe",
    "Gruppenbezeichnung",
    "Hauptfunktion",
    "Hauptfunktionsbezeichnung",
    "Oberfunktion",
    "Oberfunktionsbezeichnung",
    "Funktion",
    "Funktionsbezeichnung",
    "Titelart",
    "Titel",
    "Titelbezeichnung",
    "Jahr",
    "BetragTyp",
    "Betrag",
    "ID"
FROM nachtragshaushalt_opendata_22_23
UNION ALL
SELECT
    "Typ",
    "Bezeichnung",
    "Bereich",
    "Bereichsbezeichnung",
    "Einzelplan",
    "Einzelplanbezeichnung",
    "Kapitel",
    "Kapitelbezeichnung",
    "Hauptgruppe",
    "Hauptgruppenbezeichnung",
    "Obergruppe",
    "Obergruppenbezeichnung",
    "Gruppe",
    "Gruppenbezeichnung",
    "Hauptfunktion",
    "Hauptfunktionsbezeichnung",
    "Oberfunktion",
    "Oberfunktionsbezeichnung",
    "Funktion",
    "Funktionsbezeichnung",
    "Titelart",
    "Titel",
    "Titelbezeichnung",
    "Jahr",
    "BetragTyp",
    "Betrag",
    "ID"
FROM haushaltsdaten_2024_2025;

```

When using the combined table make sure to update the ftc function for the remote procedure calls to also point at the `hausahltsdaten_combined` table.

```sql
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

```

### Refresh the materialized view

To refresh the materialized view you can use the following command:

```sql
REFRESH MATERIALIZED VIEW haushaltsdaten_current;
REFRESH MATERIALIZED VIEW haushaltsdaten_combined;
```

We recommend to do this locally and afterwards push these changes to the remote database. Within this repo you will find an [workflow](./.github/workflows/deploy-to-supabase.yml) that updates the production database using GitHub Actions.

```bash
supabase start
# make your adjustments
git switch -c your-update-data-branch
db diff --file <your migration name> --schema public --use-migra
git add .
git commit -m "your commit message"
git push origin your-update-data-branch
```

Create your pull request against the `main` branch. Once merged the workflow will run and update the production database.

Then populate the new table on the remote with the new data and refresh your materialized views.

```sql
REFRESH MATERIALIZED VIEW haushaltsdaten_current;
REFRESH MATERIALIZED VIEW haushaltsdaten_combined;
```

## Usage Functions

The functions are currently not used in production. They where meant to be used as endpoint to obtain the data for the treemap view pre configured. We de this currently in the frontend.

```bash
# Make a request to get the all the `Einnahmetitel` data:
curl -L -X POST 'https://zrbypchhbikbfvgqptbk.functions.supabase.co/treemap-data' -H 'Authorization: Bearer <YOUR ANON KEY HERE>'
# Make a request to get the all the `Ausgabetitel` data:
curl -L -X POST 'https://zrbypchhbikbfvgqptbk.functions.supabase.co/treemap-data?type=Ausgabetitel' -H 'Authorization: Bearer <YOUR ANON KEY HERE>'
# Make a request to get the all the `Einnahmetitel` data for the area Mitte
# The areas can be filtered with the following queries
#
# key: "hauptverwaltung" gives you: "Hauptverwaltung",
# key: "pankow" gives you: "Pankow",
# key: "reinickendorf" gives you: "Reinickendorf",
# key: "steglitz_zehlendorf" gives you: "Steglitz-Zehlendorf",
# key: "friedrichshain_kreuzberg" gives you: "Friedrichshain-Kreuzberg",
# key: "marzahn_hellersdorf" gives you: "Marzahn-Hellersdorf",
# key: "neukoelln" gives you: "Neukölln",
# key: "lichtenberg" gives you: "Lichtenberg",
# key: "treptow_koepenick" gives you: "Treptow-Köpenick",
# key: "tempelhof_schoeneberg" gives you: "Tempelhof-Schöneberg",
# key: "spandau" gives you: "Spandau",
# key: "mitte" gives you: "Mitte",
# key: "charlottenburg_wilmersdorf" gives you: "Charlottenburg-Wilmersdorf",
#
curl -L -X POST 'https://zrbypchhbikbfvgqptbk.functions.supabase.co/treemap-data?bezirk=mitte' -H 'Authorization: Bearer <YOUR ANON KEY HERE>'
```

## Contributing

Please see the issues in the repo https://github.com/berlin/haushaltsdaten/issues if you like to contribute or open a new one.

### Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://fabianmoronzirfas.me/"><img src="https://avatars.githubusercontent.com/u/315106?v=4?s=128" width="128px;" alt=""/><br /><sub><b>Fabian Morón Zirfas</b></sub></a><br /><a href="https://github.com/berlin/haushaltsdaten-supabase/commits?author=ff6347" title="Documentation">📖</a> <a href="https://github.com/berlin/haushaltsdaten-supabase/commits?author=ff6347" title="Code">💻</a> <a href="#design-ff6347" title="Design">🎨</a> <a href="#infra-ff6347" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

## Content Licensing

Files in folder [`./data`](/data) and the file [`./supabase/seed.sql`](./supabase/seed.sql) are available as [CC BY](https://creativecommons.org/licenses/by/3.0/de/) from [daten.berlin.de](https://daten.berlin.de/datensaetze)

## Credits

<table>
  <tr>
    <td>
      Made by <a src="https://citylab-berlin.org/de/start/">
        <br />
        <br />
        <img width="200" src="https://citylab-berlin.org/wp-content/uploads/2021/05/citylab-logo.svg" />
      </a>
    </td>
    <td>
      A project by <a src="https://www.technologiestiftung-berlin.de/">
        <br />
        <br />
        <img width="150" src="https://citylab-berlin.org/wp-content/uploads/2021/05/tsb.svg" />
      </a>
    </td>
    <td>
      Supported by <a src="https://www.berlin.de/rbmskzl/">
        <br />
        <br />
        <img width="80" src="https://citylab-berlin.org/wp-content/uploads/2021/12/B_RBmin_Skzl_Logo_DE_V_PT_RGB-300x200.png" />
      </a>
    </td>
  </tr>
</table>

## Related Projects
