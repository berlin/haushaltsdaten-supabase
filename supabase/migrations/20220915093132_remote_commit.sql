ALTER TABLE IF EXISTS public.haushaltsdaten_22_23 ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users" ON public.haushaltsdaten_22_23 AS PERMISSIVE
	FOR SELECT TO public
		USING (TRUE);

