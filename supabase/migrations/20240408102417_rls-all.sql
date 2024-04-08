alter table "public"."haushaltsdaten_2024_2025" enable row level security;

alter table "public"."nachtragshaushalt_opendata_22_23" enable row level security;

create policy "Enable read access for all users"
on "public"."haushaltsdaten_2024_2025"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."nachtragshaushalt_opendata_22_23"
as permissive
for select
to public
using (true);



