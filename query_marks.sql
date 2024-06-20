\set QUIET 1

CREATE OR REPLACE FUNCTION check_marks(perem TEXT)
RETURNS VOID AS $$
BEGIN
  -- RAISE NOTICE 'Parameter passed in the script --- % ---', perem;
  IF EXISTS (SELECT * FROM "active_marks_common" WHERE mark LIKE '%' || perem || '%') THEN
    RAISE NOTICE '% >>> MARK FOUND', perem;
  ELSE
    RAISE NOTICE '% >>> #########', perem;
  END IF;
END;
$$ LANGUAGE plpgsql;

SELECT check_marks(:gtin);
