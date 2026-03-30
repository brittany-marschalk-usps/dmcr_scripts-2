--------------------------------------------------------------------------------
-- DMCR #:        <DMCR_ID>
-- ENVIRONMENT:   <ODS|RPTG|TRK>
-- ENV SPECIFIC:  <Y|N>
-- RELEASE:       R<Release>
-- SUMMARY:       <SUMMARY>
-- OBJECTS:       <OBJECTS>
-- JUSTIFICATION: <WORK_ITEM_TYPE_ABBR><WORK_ITEM_NUM> - <WORK_ITEM_DESC>
-- -----------------------------------------------------------------------------

<DDL>

<DML>

DECLARE
   lr_dtc       dmcr_track_control%ROWTYPE;
   lv_dmcr_id   dmcr_track_control.dmcr_id%TYPE := '<DMCR_ID>';
BEGIN

   lr_dtc.dmcr_id          := lv_dmcr_id;
   lr_dtc.ptr_release      := '<Release>';
   lr_dtc.create_datetime  := SYSDATE;
   lr_dtc.work_item_type   := '<WORK_ITEM_TYPE>';
   lr_dtc.work_item_number := <WORK_ITEM_NUM>;
   lr_dtc.dmcr_desc        := '<SUMMARY>';
   INSERT INTO dmcr_track_control VALUES lr_dtc;
 
   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END;
/
