// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.131.0/http/server.ts";
// import postgres from "https://deno.land/x/postgresjs/mod.js";
// import _ from "https://deno.land/x/lodash@4.17.19/lodash.js";

// const host = Deno.env.get("POSTGRES_HOST") || "localhost";
// const s_port = Deno.env.get("POSTGRES_PORT") || "54322";
// const user = Deno.env.get("POSTGRES_USER") || "postgres";
// const password = Deno.env.get("POSTGRES_PASSWORD") || "postgres";
// const database = Deno.env.get("POSTGRES_DATABASE") || "postgres";
// const port = parseInt(s_port, 10);
// const sql = postgres({
// 	host,
// 	port,
// 	user,
// 	password,
// 	database,
// });
// import { groupBy } from "https://raw.githubusercontent.com/lodash/lodash/4.17.21-es/lodash.js";

import { createClient } from "https://esm.sh/@supabase/supabase-js@1.35.3";
const groupBy = (obj: Record<string, any>, prop: string) => {
	return obj.reduce((acc: any, item: Record<string, any>) => {
		if (!acc[item[prop]]) {
			acc[item[prop]] = [];
		}
		acc[item[prop]].push(item);
		return acc;
	}, {});
};
const calcValue = (arr: { betrag: string }[]) => {
	return arr
		.map((item) => (!isNaN(parseInt(item.betrag)) ? parseInt(item.betrag) : 0))
		.reduce((acc, curr) => acc + curr, 0);
};
const supabaseClient = createClient(
	// Supabase API URL - env var exported by default when deployed.
	Deno.env.get("SUPABASE_URL") ?? "http://localhost:54321",
	// Supabase API ANON KEY - env var exported by default when deployed.
	Deno.env.get("SUPABASE_ANON_KEY") ??
		"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24ifQ.625_WdcF3KHqz5amU0x2X5WWHP-OEs_4qj0ssLNHzTs",
);

const data: { name: string; children: unknown[] } = {
	name: "Übersicht",
	children: [],
};
let bezirk = "";
// const bezirke = [
// 	"hauptverwaltung",
// 	"pankow",
// 	"reinickendorf",
// 	"steglitz_zehlendorf",
// 	"friedrichshain_kreuzberg",
// 	"marzahn_hellersdorf",
// 	"neukoelln",
// 	"lichtenberg",
// 	"treptow_koepenick",
// 	"tempelhof_schoeneberg",
// 	"spandau",
// 	"mitte",
// 	"charlottenburg_wilmersdorf",
// ];

const bezirkeHashMap: Record<string, string> = {
	hauptverwaltung: "Hauptverwaltung",
	pankow: "Pankow",
	reinickendorf: "Reinickendorf",
	steglitz_zehlendorf: "Steglitz-Zehlendorf",
	friedrichshain_kreuzberg: "Friedrichshain-Kreuzberg",
	marzahn_hellersdorf: "Marzahn-Hellersdorf",
	neukoelln: "Neukölln",
	lichtenberg: "Lichtenberg",
	treptow_koepenick: "Treptow-Köpenick",
	tempelhof_schoeneberg: "Tempelhof-Schöneberg",
	spandau: "Spandau",
	mitte: "Mitte",
	charlottenburg_wilmersdorf: "Charlottenburg-Wilmersdorf",
};
const bezirkKeys = Object.entries(bezirkeHashMap).map(
	([key, _]: [string, string]) => key,
);
// const bezirkValues = Object.entries(bezirkeHashMap).map(
// 	([_, value]: [string, string]) => value,
// );
const types = ["Einnahmetitel", "Ausgabetitel"];
// const filterByBezirk = (bezirk: string) => sql`and bezirk = ${bezirk}`;
serve(async (req) => {
	try {
		const searchParams = new URL(req.url).searchParams;
		let typeFilter = types[0];
		let hasBezirkFilter = false;
		if (searchParams.has("type")) {
			if (!types.includes(searchParams.get("type")!)) {
				return new Response(
					JSON.stringify({
						message: `type must be one of ${types.join(", ")}`,
					}),
					{
						status: 400,
						headers: { "Content-Type": "application/json" },
					},
				);
			}
			if (searchParams.get("type") === "Ausgabetitel") {
				typeFilter = searchParams.get("type")!;
			}
		}
		if (searchParams.has("bezirk")) {
			if (!bezirkKeys.includes(searchParams.get("bezirk")!)) {
				return new Response(
					JSON.stringify({
						message: `bezirke must be one of ${bezirkKeys.join(", ")}`,
					}),
					{
						status: 400,
						headers: { "Content-Type": "application/json" },
					},
				);
			}
			bezirk = bezirkeHashMap[searchParams.get("bezirk")!];
			hasBezirkFilter = true;
		}
		let query = supabaseClient
			.from("haushaltsdaten_2022")
			.select("*")
			.eq("titel_art", typeFilter);
		if (hasBezirkFilter) {
			query = query.eq("bereichs_bezeichnung", bezirk);
		}
		const { data: result, error: dataError } = await query;

		// TODO: Make bezirk filtering work
		// .contains(
		// 	"bereichs_bezeichnung",
		// 	hasBezirkFilter ? [bezirk] : bezirkValues,
		// );
		if (dataError) {
			console.error(dataError);
			throw new Error(dataError.message);
		}
		if (!result) {
			console.error(dataError);
			throw new Error("no data found");
		}
		let res = groupBy(result, "hauptfunktion");
		result.forEach((item, i, arr) => {
			delete item.search_document;
			arr[i].value = calcValue([item]);
			arr[i] = item;
		});
		res = Object.keys(res).map((key) => {
			return {
				name: res[key][0].hauptfunktion,
				desc: res[key][0].hauptfunktions_bezeichnung,
				type: "hauptfunktion",
				value: calcValue(res[key]),
				children: groupBy(res[key], "oberfunktion"),
			};
		});

		res = res.map((hf: any) => {
			return {
				...hf,
				children: Object.keys(hf.children).map((key) => {
					return {
						name: hf.children[key][0].oberfunktion,
						desc: hf.children[key][0].oberfunktions_bezeichnung,
						type: "oberfunktion",
						value: calcValue(hf.children[key]),
						children: groupBy(hf.children[key], "funktion"),
					};
				}),
			};
		});

		res = res.map((hf: any) => {
			return {
				...hf,
				children: hf.children.map((of: any) => {
					return {
						...of,
						children: Object.keys(of.children).map((key) => {
							return {
								name: of.children[key][0].funktion,
								desc: of.children[key][0].funktions_bezeichnung,
								type: "funktion",
								value: calcValue(of.children[key]),
								children: of.children[key],
							};
						}),
					};
				}),
			};
		});
		/*
		// I really would like to not use the SDK and
		// only use the postgres.js library. But I'm having an error
		//{"message":"write CONNECTION_ENDED localhost:54322"}D
		// {"message":"Connection refused (os error 111)"}

		 const result = await sql`
		 SELECT * FROM haushaltsdaten_2022 WHERE titel_art ={typeFilter} ${
		 	hasBezirkFilter ? filterByBezirk(bezirk) : sql``
		 }`;
    */
		data.children = res;
		return new Response(JSON.stringify(data), {
			status: 200,
			headers: { "Content-Type": "application/json" },
		});
	} catch (error) {
		return new Response(JSON.stringify({ message: error.message }), {
			status: 500,
			headers: { "Content-Type": "application/json" },
		});
	} finally {
		// sql.end();
	}
});

// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24ifQ.625_WdcF3KHqz5amU0x2X5WWHP-OEs_4qj0ssLNHzTs' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'
