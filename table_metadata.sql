DECLARE
   lr_tm   table_metadata%ROWTYPE;
BEGIN

   lr_tm.table_name       := '<TABLE_NAME>';
   lr_tm.short_table_name := '<TABLE_ABBR>';
   lr_tm.create_datetime  := SYSDATE;
   INSERT INTO table_metadata VALUES lr_tm;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END;
/
