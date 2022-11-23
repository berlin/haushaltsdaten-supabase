import { createClient } from "https://esm.sh/@supabase/supabase-js@1.35.3";

const supabase = createClient(
	"http://localhost:54321",
	"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24ifQ.625_WdcF3KHqz5amU0x2X5WWHP-OEs_4qj0ssLNHzTs",
);

const { data, error, count } = await supabase.rpc(
	"ftc",
	{ search: "mitte" },
	{ count: "exact" },
);

if (error) {
	console.error(error);
	throw error;
}
console.log(data, count);
