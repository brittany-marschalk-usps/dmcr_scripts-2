--------------------------------------------------------------------------------
-- DMCR #:        99998
-- ENVIRONMENT:   ODS
-- ENV SPECIFIC:  N
-- RELEASE:       R26.3.1
-- SUMMARY:       Test Table Creation
-- OBJECTS:       TEST_CONTROL
-- JUSTIFICATION: CMC1234 - Generic CMC
-- -----------------------------------------------------------------------------

DECLARE
   ln_bpk_cnt   product_header.barcode_partition_key%TYPE;
   lv_ddl       VARCHAR2(32767);
BEGIN

   SELECT TO_NUMBER(value)
   INTO ln_bpk_cnt
   FROM config_value
   WHERE category_name = 'PARTITION_KEY'
   AND   config_name = 'BPK_CNT';

   lv_ddl := q'[
CREATE TABLE TEST_CONTROL
   (test_table_id           NUMBER(13)     NOT NULL,
    date_partition_key      NUMBER(4)      NOT NULL,
    barcode_partition_key   NUMBER(4)      NOT NULL,
    create_datetime         DATE           NOT NULL)
TABLESPACE pts2_app_data_01_ts PCTFREE 10 INITRANS 10
PARTITION BY LIST (date_partition_key) 
SUBPARTITION BY LIST (barcode_partition_key) 
SUBPARTITION TEMPLATE
(]';

   FOR i IN 1..ln_bpk_cnt LOOP
      lv_ddl := lv_ddl || 'SUBPARTITION bpk_' || i || ' VALUES (' || i || '),' || CHR(13) || CHR(10);
   END LOOP;

   lv_ddl := SUBSTR(lv_ddl, 1, LENGTH(lv_ddl) - 3) || ')' || CHR(13) || CHR(10) ||
      '(PARTITION testctrl_4750 VALUES(4750))'; -- 1/1/2025
   EXECUTE IMMEDIATE lv_ddl;

EXCEPTION
    WHEN OTHERS THEN
       ROLLBACK;
       RAISE;
END;
/

DECLARE
   lr_pc   partition_control%ROWTYPE;
BEGIN
   lr_pc.run_group                  := 4;
   lr_pc.table_name                 := 'TEST_CONTROL';
   lr_pc.thread_val                 := 1;
   lr_pc.tablespace_name            := 'PTS2_APP_DATA_01_TS';
   lr_pc.initrans_val               := 10;
   lr_pc.add_offset_days            := 14;
   lr_pc.drop_offset_days           := 150;
   lr_pc.stats_export_offset_days   := 0;
   lr_pc.run_freq_unit              := '2';
   lr_pc.run_freq                   := 1;
   lr_pc.activity_day               := '2';
   lr_pc.partition_type             := '6';
   lr_pc.partition_range_length     := NULL;
   lr_pc.last_updt_datetime         := SYSDATE;
   lr_pc.create_datetime            := SYSDATE;
   lr_pc.drop_partition_ind         := 'N';
   lr_pc.add_part_increment_val     := 1;
   lr_pc.drop_part_increment_val    := 1;
   lr_pc.multi_part_add_ind         := 'N';
   lr_pc.multi_part_drop_ind        := 'N';
   lr_pc.drop_empty_part_only_ind   := 'N';
   lr_pc.log_ddl_ind                := 'Y';
   lr_pc.part_maint_thread_ovrd_ind := 'N';
   lr_pc.add_drop_offset_part_ind   := 'N';
   lr_pc.copy_stats_ind             := NULL;
   lr_pc.warn_threshold             := NULL;
   lr_pc.error_threshold            := NULL;
   INSERT INTO partition_control VALUES lr_pc;

   pts2_part_util.add_partitions
      ('TEST_CONTROL',
       TRUNC(SYSDATE) - 120,
       TRUNC(SYSDATE) + 14);

   pts2_part_util.drop_partitions
      ('TEST_CONTROL',
       TO_DATE('20250101', 'yyyymmdd'),
       TO_DATE('20250101', 'yyyymmdd'));

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END;
/

COMMENT ON TABLE TEST_CONTROL IS 'Test Table Creation';

COMMENT ON COLUMN TEST_CONTROL.test_table_id IS 'Surrogate primary key for the test control record.';
COMMENT ON COLUMN TEST_CONTROL.date_partition_key IS 'Partition key representing the date dimension (YYDDD format).';
COMMENT ON COLUMN TEST_CONTROL.barcode_partition_key IS 'Subpartition key representing the barcode partition bucket.';
COMMENT ON COLUMN TEST_CONTROL.create_datetime IS 'Date and time the record was created.';

DECLARE
   lr_tm   table_metadata%ROWTYPE;
BEGIN

   lr_tm.table_name       := 'TEST_CONTROL';
   lr_tm.short_table_name := 'TESTCTRL';
   lr_tm.create_datetime  := SYSDATE;
   INSERT INTO table_metadata VALUES lr_tm;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END;
/

DECLARE
   lr_dtc       dmcr_track_control%ROWTYPE;
   lv_dmcr_id   dmcr_track_control.dmcr_id%TYPE := '99998';
BEGIN

   lr_dtc.dmcr_id          := lv_dmcr_id;
   lr_dtc.ptr_release      := '26.3.1';
   lr_dtc.create_datetime  := SYSDATE;
   lr_dtc.work_item_type   := 'CMC';
   lr_dtc.work_item_number := 1234;
   lr_dtc.dmcr_desc        := 'Test Table Creation';
   INSERT INTO dmcr_track_control VALUES lr_dtc;
 
   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END;
/
