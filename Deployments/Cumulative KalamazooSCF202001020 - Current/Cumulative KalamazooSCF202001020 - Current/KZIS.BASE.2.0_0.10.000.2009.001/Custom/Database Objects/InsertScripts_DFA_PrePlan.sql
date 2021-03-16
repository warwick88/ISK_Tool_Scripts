
BEGIN   TRY 
   BEGIN    TRANSACTION 
      DECLARE @DFAJavaScript VARCHAR(MAX) 
	   
	 DECLARE @FormGUID VARCHAR(100) 
    SET @FormGUID='2C489D56-66EF-4C48-939C-501A5449D387'
  
  IF NOT EXISTS (SELECT * FROM Forms WHERE FormGUID = @FormGUID  AND ISNULL(RecordDeleted,'N')<>'Y')
  BEGIN
      SET
         @DFAJavaScript = '''' 
         DECLARE @FormIds table (FormId int) 
         DECLARE @FormId INT, @FormSectionId INT, @FormSectionGroupId INT 
         DECLARE @NewFormSection TABLE ( NewFormSectionId int not null, OldFormSectionId int not null) 
         DECLARE @NewFormSectionGroup TABLE ( NewFormSectionGroupId int not null, OldFormSectionGroupId int not null) 
         INSERT INTO
            forms(formname, TableName, TotalNumberOfColumns, Active, RetrieveStoredProcedure, FormType, FormJavascript, IsJavascriptOverride, Core,FormGUID) OUTPUT INSERTED.FormId INTO @FormIds 
         values
            (
               'Pre-Planning Worksheet', 'CustomDocumentPrePlanningWorksheet', 1, 'Y', '', '9469', @DFAJavaScript, 'N', 'N',@FormGUID
            )
         SET @FormId =  ( SELECT TOP 1 FormId  FROM @FormIds )

            INSERT INTO
               dbo.FormSections(formid, SortOrder, PlaceOnTopOfPage, SectionLabel, Active, SectionEnableCheckBox, SectionEnableCheckBoxText, SectionEnableCheckBoxColumnName, NumberOfColumns) OUTPUT INSERTED.FormSectionId,
               '50068' INTO @NewFormSection 
            values
               (
                  @FormId, 1, NULL, 'Pre-Planning Worksheet', 'Y', 'N', NULL, NULL, 1
               )
               INSERT INTO
                  dbo.FormSections(formid, SortOrder, PlaceOnTopOfPage, SectionLabel, Active, SectionEnableCheckBox, SectionEnableCheckBoxText, SectionEnableCheckBoxColumnName, NumberOfColumns) OUTPUT INSERTED.FormSectionId,
                  '50070' INTO @NewFormSection 
               values
                  (
                     @FormId, 3, NULL, 'Service Planning Options', 'Y','N', NULL,  NULL,  1
                  )
                  INSERT INTO
                     dbo.FormSections(formid, SortOrder, PlaceOnTopOfPage, SectionLabel, Active, SectionEnableCheckBox, SectionEnableCheckBoxText, SectionEnableCheckBoxColumnName, NumberOfColumns) OUTPUT INSERTED.FormSectionId,
                     '50071' INTO @NewFormSection 
                  values
                     (
                        @FormId, 4, NULL, 'At my Person/Family-Centered Planning meeting:', 'Y', 'N', NULL, NULL, 1
                     )
                     INSERT INTO
                        dbo.FormSections(formid, SortOrder, PlaceOnTopOfPage, SectionLabel, Active, SectionEnableCheckBox, SectionEnableCheckBoxText, SectionEnableCheckBoxColumnName, NumberOfColumns) OUTPUT INSERTED.FormSectionId,
                        '50072' INTO @NewFormSection 
                     values
                        (
                           @FormId, 2, NULL, 'Areas I might want to work on:', 'Y', 'N',  NULL,  NULL, 1
                        )
                        INSERT INTO
                           dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                           '50140' INTO @NewFormSectionGroup 
                        VALUES
                           (
                          ( SELECT TOP 1 NewFormSectionId  FROM  @NewFormSection WHERE OldFormSectionId = 50068),
                                 1,  NULL, 'Y', 'N', NULL, NULL,  '2',  NULL
                           )
                           INSERT INTO
                              dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                              '50141' INTO @NewFormSectionGroup 
                           VALUES
                              (
                              ( SELECT TOP 1 NewFormSectionId  FROM  @NewFormSection  WHERE OldFormSectionId = 50068),
                                    2, '<b>My dreams and desires for the future are:</b>','Y', 'N', NULL,  NULL,  '1', NULL
                              )
                              INSERT INTO
                                 dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                 '50142' INTO @NewFormSectionGroup 
                              VALUES
                                 (
                                  ( SELECT   TOP 1 NewFormSectionId   FROM  @NewFormSection WHERE OldFormSectionId = 50068),
                                       3,  '<b>How services can help to get there:</b>',  'Y',  'N',   NULL,  NULL,  '1',  NULL
                                 )
                                 INSERT INTO
                                    dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                    '50145' INTO @NewFormSectionGroup 
                                 VALUES
                                    (
                                   ( SELECT  TOP 1 NewFormSectionId    FROM  @NewFormSection   WHERE  OldFormSectionId = 50070),
                                          1, NULL,  'Y', 'N', NULL,  NULL,    '2', NULL
                                    )
                                    INSERT INTO
                                       dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                       '50146' INTO @NewFormSectionGroup 
                                    VALUES
                                       (
                                 ( SELECT  TOP 1 NewFormSectionId  FROM  @NewFormSection  WHERE OldFormSectionId = 50070),
                                             2, NULL, 'Y', 'N', NULL,  NULL, '3', NULL )
      INSERT INTO dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                          '50147' 
		 INTO @NewFormSectionGroup    VALUES   (( SELECT  TOP 1 NewFormSectionId  FROM
                                                @NewFormSection  WHERE    OldFormSectionId = 50070),
         3, 'Comments about PCP and/or SD','Y', 'N', NULL, NULL, '1', NULL)
       INSERT INTO dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                             '50148'
		  INTO @NewFormSectionGroup  VALUES (
                  (  SELECT  TOP 1 NewFormSectionId  FROM  @NewFormSection  WHERE  OldFormSectionId = 50071),
                 1, 'A. It is important to me to talk about', 'Y',  'N', NULL, NULL, '1', NULL )
           INSERT INTO  dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                                '50149'
			 INTO @NewFormSectionGroup  VALUES (
			 ( SELECT  TOP 1 NewFormSectionId  FROM  @NewFormSection   WHERE OldFormSectionId = 50071),
               2,  'B. It is important to me we NOT talk about:', 'Y',   'N', NULL, NULL,  '1',  NULL  )
              INSERT INTO  dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                                   '50150'			
			  INTO @NewFormSectionGroup   VALUES (
                    ( SELECT  TOP 1 NewFormSectionId   FROM  @NewFormSection  WHERE  OldFormSectionId = 50071),
                  3, 'C. Wellness, Health, and Safety issues I would like to talk about: ',
                    'Y', 'N',  NULL, NULL, '1', NULL )
                  INSERT INTO  dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                                      '50151'
				  INTO @NewFormSectionGroup  VALUES  (
                    (  SELECT  TOP 1 NewFormSectionId  FROM @NewFormSection  WHERE OldFormSectionId = 50071),
                   4, 'D. The Customer Handbook was reviewed with me including covered services.  I am interested in discussing the following services at my planning meeting to help me meet my goals. (Services are based upon need and medical/clinical necessity):',
                     'Y', 'N',  NULL,  NULL, '1', NULL )
                    INSERT INTO  dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                                         '50152'
					 INTO @NewFormSectionGroup  VALUES (
                         (   SELECT  TOP 1 NewFormSectionId  FROM  @NewFormSection  WHERE  OldFormSectionId = 50071),
                                                               5,
                                                               'E. I was provided information from the Provider Directory about different options of Providers for covered services.  I would like to discuss pursuing the following options for service providers:',
                                                               'Y',
                                                               'N',
                                                               NULL,
                                                               NULL,
                                                               '1',
                                                               NULL
                                                         )
                                                         INSERT INTO
                                                            dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                                            '50153' INTO @NewFormSectionGroup 
                                                         VALUES
                                                            (
(
                                                               SELECT
                                                                  TOP 1 NewFormSectionId 
                                                               FROM
                                                                  @NewFormSection 
                                                               WHERE
                                                                  OldFormSectionId = 50071),
                                                                  6,
                                                                  '<b>I would like to invite these people to my planning meeting: Emphasize family, friends and other allies.  Ask to share names of family, friends other allies they have in their lives and who they would like to invite.</b> <i>(staff, please encourage invitation to ancillary providers as appropriate)</i>',
                                                                  'Y',
                                                                  'N',
                                                                  NULL,
                                                                  NULL,
                                                                  '1',
                                                                  NULL
                                                            )
                                                            INSERT INTO
                                                               dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                                               '50154' INTO @NewFormSectionGroup 
                                                            VALUES
                                                               (
(
                                                                  SELECT
                                                                     TOP 1 NewFormSectionId 
                                                                  FROM
                                                                     @NewFormSection 
                                                                  WHERE
                                                                     OldFormSectionId = 50071),
                                                                     7,
                                                                     '<b>I do not want these people at my planning meeting:</b>',
                                                                     'Y',
                                                                     'N',
                                                                     NULL,
                                                                     NULL,
                                                                     '1',
                                                                     NULL
                                                               )
                                                               INSERT INTO
                                                                  dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                                                  '50155' INTO @NewFormSectionGroup 
                                                               VALUES
                                                                  (
(
                                                                     SELECT
                                                                        TOP 1 NewFormSectionId 
                                                                     FROM
                                                                        @NewFormSection 
                                                                     WHERE
                                                                        OldFormSectionId = 50071),
                                                                        8,
                                                                        NULL,
                                                                        'Y',
                                                                        'N',
                                                                        NULL,
                                                                        NULL,
                                                                        '6',
                                                                        NULL
                                                                  )
                                                                  INSERT INTO
                                                                     dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                                                     '50156' INTO @NewFormSectionGroup 
                                                                  VALUES
                                                                     (
(
                                                                        SELECT
                                                                           TOP 1 NewFormSectionId 
                                                                        FROM
                                                                           @NewFormSection 
                                                                        WHERE
                                                                           OldFormSectionId = 50071),
                                                                           9,
                                                                           NULL,
                                                                           'Y',
                                                                           'N',
                                                                           NULL,
                                                                           NULL,
                                                                           '2',
                                                                           NULL
                                                                     )
                                                                     INSERT INTO
                                                                        dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                                                        '50157' INTO @NewFormSectionGroup 
                                                                     VALUES
                                                                        (
(
                                                                           SELECT
                                                                              TOP 1 NewFormSectionId 
                                                                           FROM
                                                                              @NewFormSection 
                                                                           WHERE
                                                                              OldFormSectionId = 50071),
                                                                              10,
                                                                              NULL,
                                                                              'Y',
                                                                              'N',
                                                                              NULL,
                                                                              NULL,
                                                                              '3',
                                                                              NULL
                                                                        )
                                                                        INSERT INTO
                                                                           dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                                                           '50158' INTO @NewFormSectionGroup 
                                                                        VALUES
                                                                           (
(
                                                                              SELECT
                                                                                 TOP 1 NewFormSectionId 
                                                                              FROM
                                                                                 @NewFormSection 
                                                                              WHERE
                                                                                 OldFormSectionId = 50071),
                                                                                 12,
                                                                                 'Additional Comments:',
                                                                                 'Y',
                                                                                 'N',
                                                                                 NULL,
                                                                                 NULL,
                                                                                 '1',
                                                                                 NULL
                                                                           )
                                                                           INSERT INTO
                                                                              dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                                                              '50159' INTO @NewFormSectionGroup 
                                                                           VALUES
                                                                              (
(
                                                                                 SELECT
                                                                                    TOP 1 NewFormSectionId 
                                                                                 FROM
                                                                                    @NewFormSection 
                                                                                 WHERE
                                                                                    OldFormSectionId = 50071),
                                                                                    11,
                                                                                    NULL,
                                                                                    'Y',
                                                                                    'N',
                                                                                    NULL,
                                                                                    NULL,
                                                                                    '3',
                                                                                    NULL
                                                                              )
                                                                              INSERT INTO
                                                                                 dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                                                                 '50160' INTO @NewFormSectionGroup 
                                                                              VALUES
                                                                                 (
(
                                                                                    SELECT
                                                                                       TOP 1 NewFormSectionId 
                                                                                    FROM
                                                                                       @NewFormSection 
                                                                                    WHERE
                                                                                       OldFormSectionId = 50072),
                                                                                       1,
                                                                                       NULL,
                                                                                       'Y',
                                                                                       'N',
                                                                                       NULL,
                                                                                       NULL,
                                                                                       '3',
                                                                                       NULL
                                                                                 )
                                                                                 INSERT INTO
                                                                                    dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow, GroupName) OUTPUT INSERTED.FormSectionGroupId,
                                                                                    '50161' INTO @NewFormSectionGroup 
                                                                                 VALUES
                                                                                    (
(
                                                                                       SELECT
                                                                                          TOP 1 NewFormSectionId 
                                                                                       FROM
                                                                                          @NewFormSection 
                                                                                       WHERE
                                                                                          OldFormSectionId = 50072),
                                                                                          2,
                                                                                          'Additional Comments',
                                                                                          'Y',
                                                                                          'N',
                                                                                          NULL,
                                                                                          NULL,
                                                                                          '1',
                                                                                          NULL
                                                                                    )
                                                                                    INSERT INTO
                                                                                       Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                    VALUES
                                                                                       (
(
                                                                                          SELECT
                                                                                             TOP 1 NewFormSectionId 
                                                                                          FROM
                                                                                             @NewFormSection 
                                                                                          WHERE
                                                                                             OldFormSectionId = 50068),
                                                                                             (
                                                                                                SELECT
                                                                                                   TOP 1 NewFormSectionGroupId 
                                                                                                FROM
                                                                                                   @NewFormSectionGroup 
                                                                                                WHERE
                                                                                                   OldFormSectionGroupId = 50140
                                                                                             )
,
                                                                                             '5374',
                                                                                             'Individual''s Name:',
                                                                                             1,
                                                                                             'Y',
                                                                                             NULL,
                                                                                             NULL,
                                                                                             'N',
                                                                                             NULL,
                                                                                             NULL,
                                                                                             NULL,
                                                                                             NULL,
                                                                                             NULL,
                                                                                             NULL,
                                                                                             NULL,
                                                                                             NULL,
                                                                                             NULL,
                                                                                             NULL
                                                                                       )
                                                                                       INSERT INTO
                                                                                          Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                       VALUES
                                                                                          (
(
                                                                                             SELECT
                                                                                                TOP 1 NewFormSectionId 
                                                                                             FROM
                                                                                                @NewFormSection 
                                                                                             WHERE
                                                                                                OldFormSectionId = 50068),
                                                                                                (
                                                                                                   SELECT
                                                                                                      TOP 1 NewFormSectionGroupId 
                                                                                                   FROM
                                                                                                      @NewFormSectionGroup 
                                                                                                   WHERE
                                                                                                      OldFormSectionGroupId = 50140
                                                                                                )
,
                                                                                                '5374',
                                                                                                'DOB:',
                                                                                                2,
                                                                                                'Y',
                                                                                                NULL,
                                                                                                NULL,
                                                                                                'N',
                                                                                                NULL,
                                                                                                NULL,
                                                                                                NULL,
                                                                                                NULL,
                                                                                                NULL,
                                                                                                NULL,
                                                                                                NULL,
                                                                                                NULL,
                                                                                                NULL,
                                                                                                NULL
                                                                                          )
                                                                                          INSERT INTO
                                                                                             Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                          VALUES
                                                                                             (
(
                                                                                                SELECT
                                                                                                   TOP 1 NewFormSectionId 
                                                                                                FROM
                                                                                                   @NewFormSection 
                                                                                                WHERE
                                                                                                   OldFormSectionId = 50068),
                                                                                                   (
                                                                                                      SELECT
                                                                                                         TOP 1 NewFormSectionGroupId 
                                                                                                      FROM
                                                                                                         @NewFormSectionGroup 
                                                                                                      WHERE
                                                                                                         OldFormSectionGroupId = 50140
                                                                                                   )
,
                                                                                                   '5361',
                                                                                                   '',
                                                                                                   3,
                                                                                                   'Y',
                                                                                                   NULL,
                                                                                                   'IndividualName',
                                                                                                   'N',
                                                                                                   NULL,
                                                                                                   NULL,
                                                                                                   NULL,
                                                                                                   NULL,
                                                                                                   NULL,
                                                                                                   NULL,
                                                                                                   NULL,
                                                                                                   NULL,
                                                                                                   NULL,
                                                                                                   NULL
                                                                                             )
                                                                                             INSERT INTO
                                                                                                Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                             VALUES
                                                                                                (
(
                                                                                                   SELECT
                                                                                                      TOP 1 NewFormSectionId 
                                                                                                   FROM
                                                                                                      @NewFormSection 
                                                                                                   WHERE
                                                                                                      OldFormSectionId = 50068),
                                                                                                      (
                                                                                                         SELECT
                                                                                                            TOP 1 NewFormSectionGroupId 
                                                                                                         FROM
                                                                                                            @NewFormSectionGroup 
                                                                                                         WHERE
                                                                                                            OldFormSectionGroupId = 50140
                                                                                                      )
,
                                                                                                      '5367',
                                                                                                      '',
                                                                                                      4,
                                                                                                      'Y',
                                                                                                      NULL,
                                                                                                      'DOB',
                                                                                                      'N',
                                                                                                      NULL,
                                                                                                      NULL,
                                                                                                      NULL,
                                                                                                      NULL,
                                                                                                      NULL,
                                                                                                      NULL,
                                                                                                      NULL,
                                                                                                      NULL,
                                                                                                      NULL,
                                                                                                      NULL
                                                                                                )
                                                                                                INSERT INTO
                                                                                                   Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                VALUES
                                                                                                   (
(
                                                                                                      SELECT
                                                                                                         TOP 1 NewFormSectionId 
                                                                                                      FROM
                                                                                                         @NewFormSection 
                                                                                                      WHERE
                                                                                                         OldFormSectionId = 50068),
                                                                                                         (
                                                                                                            SELECT
                                                                                                               TOP 1 NewFormSectionGroupId 
                                                                                                            FROM
                                                                                                               @NewFormSectionGroup 
                                                                                                            WHERE
                                                                                                               OldFormSectionGroupId = 50140
                                                                                                         )
,
                                                                                                         '5374',
                                                                                                         'Case Number: ',
                                                                                                         5,
                                                                                                         'Y',
                                                                                                         NULL,
                                                                                                         NULL,
                                                                                                         'N',
                                                                                                         NULL,
                                                                                                         NULL,
                                                                                                         NULL,
                                                                                                         NULL,
                                                                                                         NULL,
                                                                                                         NULL,
                                                                                                         NULL,
                                                                                                         NULL,
                                                                                                         NULL,
                                                                                                         NULL
                                                                                                   )
                                                                                                   INSERT INTO
                                                                                                      Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                   VALUES
                                                                                                      (
(
                                                                                                         SELECT
                                                                                                            TOP 1 NewFormSectionId 
                                                                                                         FROM
                                                                                                            @NewFormSection 
                                                                                                         WHERE
                                                                                                            OldFormSectionId = 50068),
                                                                                                            (
                                                                                                               SELECT
                                                                                                                  TOP 1 NewFormSectionGroupId 
                                                                                                               FROM
                                                                                                                  @NewFormSectionGroup 
                                                                                                               WHERE
                                                                                                                  OldFormSectionGroupId = 50140
                                                                                                            )
,
                                                                                                            '5374',
                                                                                                            'Date of Pre-Plan:',
                                                                                                            6,
                                                                                                            'Y',
                                                                                                            NULL,
                                                                                                            NULL,
                                                                                                            'N',
                                                                                                            NULL,
                                                                                                            NULL,
                                                                                                            NULL,
                                                                                                            NULL,
                                                                                                            NULL,
                                                                                                            NULL,
                                                                                                            NULL,
                                                                                                            NULL,
                                                                                                            NULL,
                                                                                                            NULL
                                                                                                      )
                                                                                                      INSERT INTO
                                                                                                         Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                      VALUES
                                                                                                         (
(
                                                                                                            SELECT
                                                                                                               TOP 1 NewFormSectionId 
                                                                                                            FROM
                                                                                                               @NewFormSection 
                                                                                                            WHERE
                                                                                                               OldFormSectionId = 50068),
                                                                                                               (
                                                                                                                  SELECT
                                                                                                                     TOP 1 NewFormSectionGroupId 
                                                                                                                  FROM
                                                                                                                     @NewFormSectionGroup 
                                                                                                                  WHERE
                                                                                                                     OldFormSectionGroupId = 50140
                                                                                                               )
,
                                                                                                               '5361',
                                                                                                               '',
                                                                                                               7,
                                                                                                               'Y',
                                                                                                               NULL,
                                                                                                               'CaseNumber',
                                                                                                               'N',
                                                                                                               NULL,
                                                                                                               NULL,
                                                                                                               NULL,
                                                                                                               NULL,
                                                                                                               NULL,
                                                                                                               NULL,
                                                                                                               NULL,
                                                                                                               NULL,
                                                                                                               NULL,
                                                                                                               NULL
                                                                                                         )
                                                                                                         INSERT INTO
                                                                                                            Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                         VALUES
                                                                                                            (
                                                                                                             (
                                                                                                               SELECT
                                                                                                                  TOP 1 NewFormSectionId 
                                                                                                               FROM
                                                                                                                  @NewFormSection 
                                                                                                               WHERE
                                                                                                                  OldFormSectionId = 50068),
                                                                                                                  (
                                                                                                                     SELECT
                                                                                                                        TOP 1 NewFormSectionGroupId 
                                                                                                                     FROM
                                                                                                                        @NewFormSectionGroup 
                                                                                                                     WHERE
                                                                                                                        OldFormSectionGroupId = 50140
                                                                                                                  )
                                                                                                                  ,
                                                                                                                  '5367',
                                                                                                                  '',
                                                                                                                  8,
                                                                                                                  'Y',
                                                                                                                  NULL,
                                                                                                                  'DateOfPrePlan',
                                                                                                                  'N',
                                                                                                                  NULL,
                                                                                                                  NULL,
                                                                                                                  NULL,
                                                                                                                  NULL,
                                                                                                                  NULL,
                                                                                                                  NULL,
                                                                                                                  NULL,
                                                                                                                  NULL,
                                                                                                                  NULL,
                                                                                                                  NULL
                                                                                                            )
                                                                                                            INSERT INTO
                                                                                                               Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                            VALUES
                                                                                                               (
                                                                                                                 (
                                                                                                                  SELECT
                                                                                                                     TOP 1 NewFormSectionId 
                                                                                                                  FROM
                                                                                                                     @NewFormSection 
                                                                                                                  WHERE
                                                                                                                     OldFormSectionId = 50068),
                                                                                                                     (
                                                                                                                        SELECT
                                                                                                                           TOP 1 NewFormSectionGroupId 
                                                                                                                        FROM
                                                                                                                           @NewFormSectionGroup 
                                                                                                                        WHERE
                                                                                                                           OldFormSectionGroupId = 50141
                                                                                                                     )
                                                                                                                        ,
                                                                                                                     '5361',
                                                                                                                     '',
                                                                                                                     1,
                                                                                                                     'Y',
                                                                                                                     NULL,
                                                                                                                     'DreamsAndDesires',
                                                                                                                     'N',
                                                                                                                     NULL,
                                                                                                                     500,
                                                                                                                     NULL,
                                                                                                                     NULL,
                                                                                                                     NULL,
                                                                                                                     NULL,
                                                                                                                     NULL,
                                                                                                                     NULL,
                                                                                                                     20,
                                                                                                                     NULL
                                                                                                               )
                                                                                                               INSERT INTO
                                                                                                                  Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                               VALUES
                                                                                                                  (
                                                                                                                    (
                                                                                                                     SELECT
                                                                                                                        TOP 1 NewFormSectionId 
                                                                                                                     FROM
                                                                                                                        @NewFormSection 
                                                                                                                     WHERE
                                                                                                                        OldFormSectionId = 50068),
                                                                                                                        (
                                                                                                                           SELECT
                                                                                                                              TOP 1 NewFormSectionGroupId 
                                                                                                                           FROM
                                                                                                                              @NewFormSectionGroup 
                                                                                                                           WHERE
                                                                                                                              OldFormSectionGroupId = 50142
                                                                                                                        )
                                                                                                                          ,
                                                                                                                        '5361',
                                                                                                                        '',
                                                                                                                        1,
                                                                                                                        'Y',
                                                                                                                        NULL,
                                                                                                                        'HowServicesCanHelp',
                                                                                                                        'N',
                                                                                                                        NULL,
                                                                                                                        500,
                                                                                                                        NULL,
                                                                                                                        NULL,
                                                                                                                        NULL,
                                                                                                                        NULL,
                                                                                                                        NULL,
                                                                                                                        NULL,
                                                                                                                        20,
                                                                                                                        NULL
                                                                                                                  )
                                                                                                                  INSERT INTO
                                                                                                                     Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                  VALUES
                                                                                                                     (
                                                                                                                        (
                                                                                                                        SELECT
                                                                                                                           TOP 1 NewFormSectionId 
                                                                                                                        FROM
                                                                                                                           @NewFormSection 
                                                                                                                        WHERE
                                                                                                                           OldFormSectionId = 50070),
                                                                                                                           (
                                                                                                                              SELECT
                                                                                                                                 TOP 1 NewFormSectionGroupId 
                                                                                                                              FROM
                                                                                                                                 @NewFormSectionGroup 
                                                                                                                              WHERE
                                                                                                                                 OldFormSectionGroupId = 50145
                                                                                                                           )
                                                                                                                         ,
                                                                                                                           '5374',
                                                                                                                           'A. The Person/Family-Centered Planning Process was explained to me.',
                                                                                                                           1,
                                                                                                                           'Y',
                                                                                                                           NULL,
                                                                                                                           NULL,
                                                                                                                           'N',
                                                                                                                           NULL,
                                                                                                                           NULL,
                                                                                                                           NULL,
                                                                                                                           NULL,
                                                                                                                           NULL,
                                                                                                                           NULL,
                                                                                                                           NULL,
                                                                                                                           NULL,
                                                                                                                           NULL,
                                                                                                                           NULL
                                                                                                                     )
                                                                                                                     INSERT INTO
                                                                                                                        Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                     VALUES
                                                                                                                        (
                                                                                                                          (
                                                                                                                           SELECT
                                                                                                                              TOP 1 NewFormSectionId 
                                                                                                                           FROM
                                                                                                                              @NewFormSection 
                                                                                                                           WHERE
                                                                                                                              OldFormSectionId = 50070),
                                                                                                                              (
                                                                                                                                 SELECT
                                                                                                                                    TOP 1 NewFormSectionGroupId 
                                                                                                                                 FROM
                                                                                                                                    @NewFormSectionGroup 
                                                                                                                                 WHERE
                                                                                                                                    OldFormSectionGroupId = 50145
                                                                                                                              )
                                                                                                                              ,
                                                                                                                              '5365',
                                                                                                                              '',
                                                                                                                              2,
                                                                                                                              'Y',
                                                                                                                              'RADIOYN             ',
                                                                                                                              'PrePlanProcessExplained',
                                                                                                                              'N',
                                                                                                                              NULL,
                                                                                                                              NULL,
                                                                                                                              NULL,
                                                                                                                              NULL,
                                                                                                                              NULL,
                                                                                                                              NULL,
                                                                                                                              NULL,
                                                                                                                              NULL,
                                                                                                                              NULL,
                                                                                                                              NULL
                                                                                                                        )
                                                                                                                        INSERT INTO
                                                                                                                           Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                        VALUES
                                                                                                                           (
																														(
                                                                                                                              SELECT
                                                                                                                                 TOP 1 NewFormSectionId 
                                                                                                                              FROM
                                                                                                                                 @NewFormSection 
                                                                                                                              WHERE
                                                                                                                                 OldFormSectionId = 50070),
                                                                                                                                 (
                                                                                                                                    SELECT
                                                                                                                                       TOP 1 NewFormSectionGroupId 
                                                                                                                                    FROM
                                                                                                                                       @NewFormSectionGroup 
                                                                                                                                    WHERE
                                                                                                                                       OldFormSectionGroupId = 50145
                                                                                                                                 )
																															,
                                                                                                                                 '5374',
                                                                                                                                 'B. Self-Determination (SD) options were explained to me. ',
                                                                                                                                 3,
                                                                                                                                 'Y',
                                                                                                                                 NULL,
                                                                                                                                 NULL,
                                                                                                                                 'N',
                                                                                                                                 NULL,
                                                                                                                                 NULL,
                                                                                                                                 NULL,
                                                                                                                                 NULL,
                                                                                                                                 NULL,
                                                                                                                                 NULL,
                                                                                                                                 NULL,
                                                                                                                                 NULL,
                                                                                                                                 NULL,
                                                                                                                                 NULL
                                                                                                                           )
                                                                                                                           INSERT INTO
                                                                                                                              Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                           VALUES
                                                                                                                              (
																																(
                                                                                                                                 SELECT
                                                                                                                                    TOP 1 NewFormSectionId 
                                                                                                                                 FROM
                                                                                                                                    @NewFormSection 
                                                                                                                                 WHERE
                                                                                                                                    OldFormSectionId = 50070),
                                                                                                                                    (
                                                                                                                                       SELECT
                                                                                                                                          TOP 1 NewFormSectionGroupId 
                                                                                                                                       FROM
                                                                                                                                          @NewFormSectionGroup 
                                                                                                                                       WHERE
                                                                                                                                          OldFormSectionGroupId = 50145
                                                                                                                                    )
																															,
                                                                                                                                    '5365',
                                                                                                                                    '',
                                                                                                                                    4,
                                                                                                                                    'Y',
                                                                                                                                    'RADIOYN             ',
                                                                                                                                    'SelfDExplained',
                                                                                                                                    'N',
                                                                                                                                    NULL,
                                                                                                                                    NULL,
                                                                                                                                    NULL,
                                                                                                                                    NULL,
                                                                                                                                    NULL,
                                                                                                                                    NULL,
                                                                                                                                    NULL,
                                                                                                                                    NULL,
                                                                                                                                    NULL,
                                                                                                                                    NULL
                                                                                                                              )
                                                                                                                              INSERT INTO
                                                                                                                                 Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                              VALUES
                                                                                                                                 (
																																	(
                                                                                                                                    SELECT
                                                                                                                                       TOP 1 NewFormSectionId 
                                                                                                                                    FROM
                                                                                                                                       @NewFormSection 
                                                                                                                                    WHERE
                                                                                                                                       OldFormSectionId = 50070),
                                                                                                                                       (
                                                                                                                                          SELECT
                                                                                                                                             TOP 1 NewFormSectionGroupId 
                                                                                                                                          FROM
                                                                                                                                             @NewFormSectionGroup 
                                                                                                                                          WHERE
                                                                                                                                             OldFormSectionGroupId = 50146
                                                                                                                                       )
																																		,
                                                                                                                                       '5374',
                                                                                                                                       'C. I want to explore SD in my planning process ',
                                                                                                                                       1,
                                                                                                                                       'Y',
                                                                                                                                       NULL,
                                                                                                                                       NULL,
                                                                                                                                       'N',
                                                                                                                                       NULL,
                                                                                                                                       NULL,
                                                                                                                                       NULL,
                                                                                                                                       NULL,
                                                                                                                                       NULL,
                                                                                                                                       NULL,
                                                                                                                                       NULL,
                                                                                                                                       NULL,
                                                                                                                                       NULL,
                                                                                                                                       NULL
                                                                                                                                 )
                                                                                                                                 INSERT INTO
                                                                                                                                    Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                 VALUES
                                                                                                                                    (
																							( SELECT  TOP 1 NewFormSectionId FROM  @NewFormSection    WHERE OldFormSectionId = 50070),
                                                                                            ( SELECT TOP 1 NewFormSectionGroupId  FROM  @NewFormSectionGroup  WHERE OldFormSectionGroupId = 50146 )
																												,
                                                                                               '5365', '', 2, 'Y', 'RADIOYNNA           ', 'WantToExploreSelfD', 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL  )
                                                                                                INSERT INTO  Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                               VALUES  (	(
                                                                                  SELECT  TOP 1 NewFormSectionId   FROM   @NewFormSection  WHERE   OldFormSectionId = 50070),
                                                                                    ( SELECT  TOP 1 NewFormSectionGroupId  FROM  @NewFormSectionGroup   WHERE  OldFormSectionGroupId = 50146  )
,
                                                                                                                                             '5374',
                                                                                                                                             '(examples: youth custom, SD Arrangement already in place)',
                                                                                                                                             3,
                                                                                                                                             'Y',
                                                                                                                                             NULL,
                                                                                                                                             NULL,
                                                                                                                                             'N',
                                                                                                                                             NULL,
                                                                                                                                             NULL,
                                                                                                                                             NULL,
                                                                                                                                             NULL,
                                                                                                                                             NULL,
                                                                                                                                             NULL,
                                                                                                                                             NULL,
                                                                                                                                             NULL,
                                                                                                                                             NULL,
                                                                                                                                             NULL
                                                                                                                                       )
                                                                                                                                       INSERT INTO
                                                                                                                                          Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                       VALUES
                                                                                                                                          (
(
                                                                                                                                             SELECT
                                                                                                                                                TOP 1 NewFormSectionId 
                                                                                                                                             FROM
                                                                                                                                                @NewFormSection 
                                                                                                                                             WHERE
                                                                                                                                                OldFormSectionId = 50070),
                                                                                                                                                (
                                                                                                                                                   SELECT
                                                                                                                                                      TOP 1 NewFormSectionGroupId 
                                                                                                                                                   FROM
                                                                                                                                                      @NewFormSectionGroup 
                                                                                                                                                   WHERE
                                                                                                                                                      OldFormSectionGroupId = 50147
                                                                                                                                                )
,
                                                                                                                                                '5361',
                                                                                                                                                '',
                                                                                                                                                1,
                                                                                                                                                'Y',
                                                                                                                                                NULL,
                                                                                                                                                'CommentsPCPOrSD',
                                                                                                                                                'N',
                                                                                                                                                NULL,
                                                                                                                                                500,
                                                                                                                                                NULL,
                                                                                                                                                NULL,
                                                                                                                                                NULL,
                                                                                                                                                NULL,
                                                                                                                                                NULL,
                                                                                                                                                NULL,
                                                                                                                                                NULL,
                                                                                                                                                NULL
                                                                                                                                          )
                                                                                                                                          INSERT INTO
                                                                                                                                             Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                          VALUES
                                                                                                                                             (
(
                                                                                                                                                SELECT
                                                                                                                                                   TOP 1 NewFormSectionId 
                                                                                                                                                FROM
                                                                                                                                                   @NewFormSection 
                                                                                                                                                WHERE
                                                                                                                                                   OldFormSectionId = 50071),
                                                                                                                                                   (
                                                                                                                                                      SELECT
                                                                                                                                                         TOP 1 NewFormSectionGroupId 
                                                                                                                                                      FROM
                                                                                                                                                         @NewFormSectionGroup 
                                                                                                                                                      WHERE
                                                                                                                                                         OldFormSectionGroupId = 50148
                                                                                                                                                   )
,
                                                                                                                                                   '5361',
                                                                                                                                                   '',
                                                                                                                                                   1,
                                                                                                                                                   'Y',
                                                                                                                                                   NULL,
                                                                                                                                                   'ImportantToTalkAbout',
                                                                                                                                                   'N',
                                                                                                                                                   NULL,
                                                                                                                                                   500,
                                                                                                                                                   NULL,
                                                                                                                                                   NULL,
                                                                                                                                                   NULL,
                                                                                                                                                   NULL,
                                                                                                                                                   NULL,
                                                                                                                                                   NULL,
                                                                                                                                                   NULL,
                                                                                                                                                   NULL
                                                                                                                                             )
                                                                                                                                             INSERT INTO
                                                                                                                                                Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                             VALUES
                                                                                                                                                (
(
                                                                                                                                                   SELECT
                                                                                                                                                      TOP 1 NewFormSectionId 
                                                                                                                                                   FROM
                                                                                                                                                      @NewFormSection 
                                                                                                                                                   WHERE
                                                                                                                                                      OldFormSectionId = 50071),
                                                                                                                                                      (
                                                                                                                                                         SELECT
                                                                                                                                                            TOP 1 NewFormSectionGroupId 
                                                                                                                                                         FROM
                                                                                                                                                            @NewFormSectionGroup 
                                                                                                                                                         WHERE
                                                                                                                                                            OldFormSectionGroupId = 50149
                                                                                                                                                      )
,
                                                                                                                                                      '5361',
                                                                                                                                                      '',
                                                                                                                                                      1,
                                                                                                                                                      'Y',
                                                                                                                                                      NULL,
                                                                                                                                                      'ImportantToNotTalkAbout',
                                                                                                                                                      'N',
                                                                                                                                                      NULL,
                                                                                                                                                      500,
                                                                                                                                                      NULL,
                                                                                                                                                      NULL,
                                                                                                                                                      NULL,
                                                                                                                                                      NULL,
                                                                                                                                                      NULL,
                                                                                                                                                      NULL,
                                                                                                                                                      NULL,
                                                                                                                                                      NULL
                                                                                                                                                )
                                                                                                                                                INSERT INTO
                                                                                                                                                   Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                VALUES
                                                                                                                                                   (
(
                                                                                                                                                      SELECT
                                                                                                                                                         TOP 1 NewFormSectionId 
                                                                                                                                                      FROM
                                                                                                                                                         @NewFormSection 
                                                                                                                                                      WHERE
                                                                                                                                                         OldFormSectionId = 50071),
                                                                                                                                                         (
                                                                                                                                                            SELECT
                                                                                                                                                               TOP 1 NewFormSectionGroupId 
                                                                                                                                                            FROM
                                                                                                                                                               @NewFormSectionGroup 
                                                                                                                                                            WHERE
                                                                                                                                                               OldFormSectionGroupId = 50150
                                                                                                                                                         )
,
                                                                                                                                                         '5361',
                                                                                                                                                         '',
                                                                                                                                                         1,
                                                                                                                                                         'Y',
                                                                                                                                                         NULL,
                                                                                                                                                         'WHSIssuesToTalkAbout',
                                                                                                                                                         'N',
                                                                                                                                                         NULL,
                                                                                                                                                         500,
                                                                                                                                                         NULL,
                                                                                                                                                         NULL,
                                                                                                                                                         NULL,
                                                                                                                                                         NULL,
                                                                                                                                                         NULL,
                                                                                                                                                         NULL,
                                                                                                                                                         NULL,
                                                                                                                                                         NULL
                                                                                                                                                   )
                                                                                                                                                   INSERT INTO
                                                                                                                                                      Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                   VALUES
                                                                                                                                                      (
(
                                                                                                                                                         SELECT
                                                                                                                                                            TOP 1 NewFormSectionId 
                                                                                                                                                         FROM
                                                                                                                                                            @NewFormSection 
                                                                                                                                                         WHERE
                                                                                                                                                            OldFormSectionId = 50071),
                                                                                                                                                            (
                                                                                                                                                               SELECT
                                                                                                                                                                  TOP 1 NewFormSectionGroupId 
                                                                                                                                                               FROM
                                                                                                                                                                  @NewFormSectionGroup 
                                                                                                                                                               WHERE
                                                                                                                                                                  OldFormSectionGroupId = 50151
                                                                                                                                                            )
,
                                                                                                                                                            '5361',
                                                                                                                                                            '',
                                                                                                                                                            1,
                                                                                                                                                            'Y',
                                                                                                                                                            NULL,
                                                                                                                                                            'ServicesToDiscussAtMeeting',
                                                                                                                                                            'N',
                                                                                                                                                            NULL,
                                                                                                                                                            500,
                                                                                                                                                            NULL,
                                                                                                                                                            NULL,
                                                                                                                                                            NULL,
                                                                                                                                                            NULL,
                                                                                                                                                            NULL,
                                                                                                                                                            NULL,
                                                                                                                                                            NULL,
                                                                                                                                                            NULL
                                                                                                                                                      )
                                                                                                                                                      INSERT INTO
                                                                                                                                                         Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                      VALUES
                                                                                                                                                         (
(
                                                                                                                                                            SELECT
                                                                                                                                                               TOP 1 NewFormSectionId 
                                                                                                                                                            FROM
                                                                                                                                                               @NewFormSection 
                                                                                                                                                            WHERE
                                                                                                                                                               OldFormSectionId = 50071),
                                                                                                                                                               (
                                                                                                                                                                  SELECT
                                                                                                                                                                     TOP 1 NewFormSectionGroupId 
                                                                                                                                                                  FROM
                                                                                                                                                                     @NewFormSectionGroup 
                                                                                                                                                                  WHERE
                                                                                                                                                                     OldFormSectionGroupId = 50152
                                                                                                                                                               )
,
                                                                                                                                                               '5361',
                                                                                                                                                               '',
                                                                                                                                                               1,
                                                                                                                                                               'Y',
                                                                                                                                                               NULL,
                                                                                                                                                               'ServiceProviderOptions',
                                                                                                                                                               'N',
                                                                                                                                                               NULL,
                                                                                                                                                               500,
                                                                                                                                                               NULL,
                                                                                                                                                               NULL,
                                                                                                                                                               NULL,
                                                                                                                                                               NULL,
                                                                                                                                                               NULL,
                                                                                                                                                               NULL,
                                                                                                                                                               NULL,
                                                                                                                                                               NULL
                                                                                                                                                         )
                                                                                                                                                         INSERT INTO
                                                                                                                                                            Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                         VALUES
                                                                                                                                                            (
(
                                                                                                                                                               SELECT
                                                                                                                                                                  TOP 1 NewFormSectionId 
                                                                                                                                                               FROM
                                                                                                                                                                  @NewFormSection 
                                                                                                                                                               WHERE
                                                                                                                                                                  OldFormSectionId = 50071),
                                                                                                                                                                  (
                                                                                                                                                                     SELECT
                                                                                                                                                                        TOP 1 NewFormSectionGroupId 
                                                                                                                                                                     FROM
                                                                                                                                                                        @NewFormSectionGroup 
                                                                                                                                                                     WHERE
                                                                                                                                                                        OldFormSectionGroupId = 50153
                                                                                                                                                                  )
,
                                                                                                                                                                  '5361',
                                                                                                                                                                  '',
                                                                                                                                                                  1,
                                                                                                                                                                  'Y',
                                                                                                                                                                  NULL,
                                                                                                                                                                  'PeopleInvitedToMeeting',
                                                                                                                                                                  'N',
                                                                                                                                                                  NULL,
                                                                                                                                                                  500,
                                                                                                                                                                  NULL,
                                                                                                                                                                  NULL,
                                                                                                                                                                  NULL,
                                                                                                                                                                  NULL,
                                                                                                                                                                  NULL,
                                                                                                                                                                  NULL,
                                                                                                                                                                  NULL,
                                                                                                                                                                  NULL
                                                                                                                                                            )
                                                                                                                                                            INSERT INTO
                                                                                                                                                               Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                            VALUES
                                                                                                                                                               (
(
                                                                                                                                                                  SELECT
                                                                                                                                                                     TOP 1 NewFormSectionId 
                                                                                                                                                                  FROM
                                                                                                                                                                     @NewFormSection 
                                                                                                                                                                  WHERE
                                                                                                                                                                     OldFormSectionId = 50071),
                                                                                                                                                                     (
                                                                                                                                                                        SELECT
                                                                                                                                                                           TOP 1 NewFormSectionGroupId 
                                                                                                                                                                        FROM
                                                                                                                                                                           @NewFormSectionGroup 
                                                                                                                                                                        WHERE
                                                                                                                                                                           OldFormSectionGroupId = 50154
                                                                                                                                                                     )
,
                                                                                                                                                                     '5361',
                                                                                                                                                                     '',
                                                                                                                                                                     1,
                                                                                                                                                                     'Y',
                                                                                                                                                                     NULL,
                                                                                                                                                                     'PeopleNotInivtedToMeeting',
                                                                                                                                                                     'N',
                                                                                                                                                                     NULL,
                                                                                                                                                                     500,
                                                                                                                                                                     NULL,
                                                                                                                                                                     NULL,
                                                                                                                                                                     NULL,
                                                                                                                                                                     NULL,
                                                                                                                                                                     NULL,
                                                                                                                                                                     NULL,
                                                                                                                                                                     NULL,
                                                                                                                                                                     NULL
                                                                                                                                                               )
                                                                                                                                                               INSERT INTO
                                                                                                                                                                  Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                               VALUES
                                                                                                                                                                  (
(
                                                                                                                                                                     SELECT
                                                                                                                                                                        TOP 1 NewFormSectionId 
                                                                                                                                                                     FROM
                                                                                                                                                                        @NewFormSection 
                                                                                                                                                                     WHERE
                                                                                                                                                                        OldFormSectionId = 50071),
                                                                                                                                                                        (
                                                                                                                                                                           SELECT
                                                                                                                                                                              TOP 1 NewFormSectionGroupId 
                                                                                                                                                                           FROM
                                                                                                                                                                              @NewFormSectionGroup 
                                                                                                                                                                           WHERE
                                                                                                                                                                              OldFormSectionGroupId = 50155
                                                                                                                                                                        )
,
                                                                                                                                                                        '5374',
                                                                                                                                                                        'I would like my planning meeting to be held at (location): ',
                                                                                                                                                                        1,
                                                                                                                                                                        'Y',
                                                                                                                                                                        NULL,
                                                                                                                                                                        NULL,
                                                                                                                                                                        'N',
                                                                                                                                                                        NULL,
                                                                                                                                                                        NULL,
                                                                                                                                                                        NULL,
                                                                                                                                                                        NULL,
                                                                                                                                                                        NULL,
                                                                                                                                                                        NULL,
                                                                                                                                                                        NULL,
                                                                                                                                                                        NULL,
                                                                                                                                                                        NULL,
                                                                                                                                                                        NULL
                                                                                                                                                                  )
                                                                                                                                                                  INSERT INTO
                                                                                                                                                                     Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                  VALUES
                                                                                                                                                                     (
(
                                                                                                                                                                        SELECT
                                                                                                                                                                           TOP 1 NewFormSectionId 
                                                                                                                                                                        FROM
                                                                                                                                                                           @NewFormSection 
                                                                                                                                                                        WHERE
                                                                                                                                                                           OldFormSectionId = 50071),
                                                                                                                                                                           (
                                                                                                                                                                              SELECT
                                                                                                                                                                                 TOP 1 NewFormSectionGroupId 
                                                                                                                                                                              FROM
                                                                                                                                                                                 @NewFormSectionGroup 
                                                                                                                                                                              WHERE
                                                                                                                                                                                 OldFormSectionGroupId = 50155
                                                                                                                                                                           )
,
                                                                                                                                                                           '5361',
                                                                                                                                                                           '',
                                                                                                                                                                           2,
                                                                                                                                                                           'Y',
                                                                                                                                                                           NULL,
                                                                                                                                                                           'MeetingLocation',
                                                                                                                                                                           'N',
                                                                                                                                                                           NULL,
                                                                                                                                                                           NULL,
                                                                                                                                                                           NULL,
                                                                                                                                                                           NULL,
                                                                                                                                                                           NULL,
                                                                                                                                                                           NULL,
                                                                                                                                                                           NULL,
                                                                                                                                                                           NULL,
                                                                                                                                                                           NULL,
                                                                                                                                                                           NULL
                                                                                                                                                                     )
                                                                                                                                                                     INSERT INTO
                                                                                                                                                                        Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                     VALUES
                                                                                                                                                                        (
(
                                                                                                                                                                           SELECT
                                                                                                                                                                              TOP 1 NewFormSectionId 
                                                                                                                                                                           FROM
                                                                                                                                                                              @NewFormSection 
                                                                                                                                                                           WHERE
                                                                                                                                                                              OldFormSectionId = 50071),
                                                                                                                                                                              (
                                                                                                                                                                                 SELECT
                                                                                                                                                                                    TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                 FROM
                                                                                                                                                                                    @NewFormSectionGroup 
                                                                                                                                                                                 WHERE
                                                                                                                                                                                    OldFormSectionGroupId = 50155
                                                                                                                                                                              )
,
                                                                                                                                                                              '5374',
                                                                                                                                                                              'on (date):',
                                                                                                                                                                              3,
                                                                                                                                                                              'Y',
                                                                                                                                                                              NULL,
                                                                                                                                                                              NULL,
                                                                                                                                                                              'N',
                                                                                                                                                                              NULL,
                                                                                                                                                                              NULL,
                                                                                                                                                                              NULL,
                                                                                                                                                                              NULL,
                                                                                                                                                                              NULL,
                                                                                                                                                                              NULL,
                                                                                                                                                                              NULL,
                                                                                                                                                                              NULL,
                                                                                                                                                                              NULL,
                                                                                                                                                                              NULL
                                                                                                                                                                        )
                                                                                                                                                                        INSERT INTO
                                                                                                                                                                           Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                        VALUES
                                                                                                                                                                           (
(
                                                                                                                                                                              SELECT
                                                                                                                                                                                 TOP 1 NewFormSectionId 
                                                                                                                                                                              FROM
                                                                                                                                                                                 @NewFormSection 
                                                                                                                                                                              WHERE
                                                                                                                                                                                 OldFormSectionId = 50071),
                                                                                                                                                                                 (
                                                                                                                                                                                    SELECT
                                                                                                                                                                                       TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                    FROM
                                                                                                                                                                                       @NewFormSectionGroup 
                                                                                                                                                                                    WHERE
                                                                                                                                                                                       OldFormSectionGroupId = 50155
                                                                                                                                                                                 )
,
                                                                                                                                                                                 '5367',
                                                                                                                                                                                 '',
                                                                                                                                                                                 4,
                                                                                                                                                                                 'Y',
                                                                                                                                                                                 NULL,
                                                                                                                                                                                 'MeetingDate',
                                                                                                                                                                                 'N',
                                                                                                                                                                                 NULL,
                                                                                                                                                                                 NULL,
                                                                                                                                                                                 NULL,
                                                                                                                                                                                 NULL,
                                                                                                                                                                                 NULL,
                                                                                                                                                                                 NULL,
                                                                                                                                                                                 NULL,
                                                                                                                                                                                 NULL,
                                                                                                                                                                                 NULL,
                                                                                                                                                                                 NULL
                                                                                                                                                                           )
                                                                                                                                                                           INSERT INTO
                                                                                                                                                                              Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                           VALUES
                                                                                                                                                                              (
(
                                                                                                                                                                                 SELECT
                                                                                                                                                                                    TOP 1 NewFormSectionId 
                                                                                                                                                                                 FROM
                                                                                                                                                                                    @NewFormSection 
                                                                                                                                                                                 WHERE
                                                                                                                                                                                    OldFormSectionId = 50071),
                                                                                                                                                                                    (
                                                                                                                                                                                       SELECT
                                                                                                                                                                                          TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                       FROM
                                                                                                                                                                                          @NewFormSectionGroup 
                                                                                                                                                                                       WHERE
                                                                                                                                                                                          OldFormSectionGroupId = 50155
                                                                                                                                                                                    )
,
                                                                                                                                                                                    '5374',
                                                                                                                                                                                    'at (time): ',
                                                                                                                                                                                    5,
                                                                                                                                                                                    'Y',
                                                                                                                                                                                    NULL,
                                                                                                                                                                                    NULL,
                                                                                                                                                                                    'N',
                                                                                                                                                                                    NULL,
                                                                                                                                                                                    NULL,
                                                                                                                                                                                    NULL,
                                                                                                                                                                                    NULL,
                                                                                                                                                                                    NULL,
                                                                                                                                                                                    NULL,
                                                                                                                                                                                    NULL,
                                                                                                                                                                                    NULL,
                                                                                                                                                                                    NULL,
                                                                                                                                                                                    NULL
                                                                                                                                                                              )
                                                                                                                                                                              INSERT INTO
                                                                                                                                                                                 Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                              VALUES
                                                                                                                                                                                 (
(
                                                                                                                                                                                    SELECT
                                                                                                                                                                                       TOP 1 NewFormSectionId 
                                                                                                                                                                                    FROM
                                                                                                                                                                                       @NewFormSection 
                                                                                                                                                                                    WHERE
                                                                                                                                                                                       OldFormSectionId = 50071),
                                                                                                                                                                                       (
                                                                                                                                                                                          SELECT
                                                                                                                                                                                             TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                          FROM
                                                                                                                                                                                             @NewFormSectionGroup 
                                                                                                                                                                                          WHERE
                                                                                                                                                                                             OldFormSectionGroupId = 50155
                                                                                                                                                                                       )
,
                                                                                                                                                                                       '5361',
                                                                                                                                                                                       '',
                                                                                                                                                                                       6,
                                                                                                                                                                                       'Y',
                                                                                                                                                                                       NULL,
                                                                                                                                                                                       'MeetingTime',
                                                                                                                                                                                       'N',
                                                                                                                                                                                       NULL,
                                                                                                                                                                                       NULL,
                                                                                                                                                                                       NULL,
                                                                                                                                                                                       NULL,
                                                                                                                                                                                       NULL,
                                                                                                                                                                                       NULL,
                                                                                                                                                                                       NULL,
                                                                                                                                                                                       NULL,
                                                                                                                                                                                       NULL,
                                                                                                                                                                                       NULL
                                                                                                                                                                                 )
                                                                                                                                                                                 INSERT INTO
                                                                                                                                                                                    Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                 VALUES
                                                                                                                                                                                    (
(
                                                                                                                                                                                       SELECT
                                                                                                                                                                                          TOP 1 NewFormSectionId 
                                                                                                                                                                                       FROM
                                                                                                                                                                                          @NewFormSection 
                                                                                                                                                                                       WHERE
                                                                                                                                                                                          OldFormSectionId = 50071),
                                                                                                                                                                                          (
                                                                                                                                                                                             SELECT
                                                                                                                                                                                                TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                             FROM
                                                                                                                                                                                                @NewFormSectionGroup 
                                                                                                                                                                                             WHERE
                                                                                                                                                                                                OldFormSectionGroupId = 50156
                                                                                                                                                                                          )
,
                                                                                                                                                                                          '5374',
                                                                                                                                                                                          'I understand that I may have a person of my choice help run my planning meeting, ',
                                                                                                                                                                                          1,
                                                                                                                                                                                          'Y',
                                                                                                                                                                                          NULL,
                                                                                                                                                                                          NULL,
                                                                                                                                                                                          'N',
                                                                                                                                                                                          NULL,
                                                                                                                                                                                          NULL,
                                                                                                                                                                                          NULL,
                                                                                                                                                                                          NULL,
                                                                                                                                                                                          NULL,
                                                                                                                                                                                          NULL,
                                                                                                                                                                                          NULL,
                                                                                                                                                                                          NULL,
                                                                                                                                                                                          NULL,
                                                                                                                                                                                          NULL
                                                                                                                                                                                    )
                                                                                                                                                                                    INSERT INTO
                                                                                                                                                                                       Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                    VALUES
                                                                                                                                                                                       (
(
                                                                                                                                                                                          SELECT
                                                                                                                                                                                             TOP 1 NewFormSectionId 
                                                                                                                                                                                          FROM
                                                                                                                                                                                             @NewFormSection 
                                                                                                                                                                                          WHERE
                                                                                                                                                                                             OldFormSectionId = 50071),
                                                                                                                                                                                             (
                                                                                                                                                                                                SELECT
                                                                                                                                                                                                   TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                FROM
                                                                                                                                                                                                   @NewFormSectionGroup 
                                                                                                                                                                                                WHERE
                                                                                                                                                                                                   OldFormSectionGroupId = 50156
                                                                                                                                                                                             )
,
                                                                                                                                                                                             '5365',
                                                                                                                                                                                             '',
                                                                                                                                                                                             2,
                                                                                                                                                                                             'Y',
                                                                                                                                                                                             'RADIOYN             ',
                                                                                                                                                                                             'UnderstandPersonOfChoice',
                                                                                                                                                                                             'N',
                                                                                                                                                                                             NULL,
                                                                                                                                                                                             NULL,
                                                                                                                                                                                             NULL,
                                                                                                                                                                                             NULL,
                                                                                                                                                                                             NULL,
                                                                                                                                                                                             NULL,
                                                                                                                                                                                             NULL,
                                                                                                                                                                                             NULL,
                                                                                                                                                                                             NULL,
                                                                                                                                                                                             NULL
                                                                                                                                                                                       )
                                                                                                                                                                                       INSERT INTO
                                                                                                                                                                                          Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                       VALUES
                                                                                                                                                                                          (
(
                                                                                                                                                                                             SELECT
                                                                                                                                                                                                TOP 1 NewFormSectionId 
                                                                                                                                                                                             FROM
                                                                                                                                                                                                @NewFormSection 
                                                                                                                                                                                             WHERE
                                                                                                                                                                                                OldFormSectionId = 50071),
                                                                                                                                                                                                (
                                                                                                                                                                                                   SELECT
                                                                                                                                                                                                      TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                   FROM
                                                                                                                                                                                                      @NewFormSectionGroup 
                                                                                                                                                                                                   WHERE
                                                                                                                                                                                                      OldFormSectionGroupId = 50156
                                                                                                                                                                                                )
,
                                                                                                                                                                                                '5374',
                                                                                                                                                                                                'Outside independent Facilitation was clearly explained to me, ',
                                                                                                                                                                                                3,
                                                                                                                                                                                                'Y',
                                                                                                                                                                                                NULL,
                                                                                                                                                                                                NULL,
                                                                                                                                                                                                'N',
                                                                                                                                                                                                NULL,
                                                                                                                                                                                                NULL,
                                                                                                                                                                                                NULL,
                                                                                                                                                                                                NULL,
                                                                                                                                                                                                NULL,
                                                                                                                                                                                                NULL,
                                                                                                                                                                                                NULL,
                                                                                                                                                                                                NULL,
                                                                                                                                                                                                NULL,
                                                                                                                                                                                                NULL
                                                                                                                                                                                          )
                                                                                                                                                                                          INSERT INTO
                                                                                                                                                                                             Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                          VALUES
                                                                                                                                                                                             (
(
                                                                                                                                                                                                SELECT
                                                                                                                                                                                                   TOP 1 NewFormSectionId 
                                                                                                                                                                                                FROM
                                                                                                                                                                                                   @NewFormSection 
                                                                                                                                                                                                WHERE
                                                                                                                                                                                                   OldFormSectionId = 50071),
                                                                                                                                                                                                   (
                                                                                                                                                                                                      SELECT
                                                                                                                                                                                                         TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                      FROM
                                                                                                                                                                                                         @NewFormSectionGroup 
                                                                                                                                                                                                      WHERE
                                                                                                                                                                                                         OldFormSectionGroupId = 50156
                                                                                                                                                                                                   )
,
                                                                                                                                                                                                   '5365',
                                                                                                                                                                                                   '',
                                                                                                                                                                                                   4,
                                                                                                                                                                                                   'Y',
                                                                                                                                                                                                   'RADIOYN             ',
                                                                                                                                                                                                   'OIFExplained',
                                                                                                                                                                                                   'N',
                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                   NULL
                                                                                                                                                                                             )
                                                                                                                                                                                             INSERT INTO
                                                                                                                                                                                                Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                             VALUES
                                                                                                                                                                                                (
(
                                                                                                                                                                                                   SELECT
                                                                                                                                                                                                      TOP 1 NewFormSectionId 
                                                                                                                                                                                                   FROM
                                                                                                                                                                                                      @NewFormSection 
                                                                                                                                                                                                   WHERE
                                                                                                                                                                                                      OldFormSectionId = 50071),
                                                                                                                                                                                                      (
                                                                                                                                                                                                         SELECT
                                                                                                                                                                                                            TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                         FROM
                                                                                                                                                                                                            @NewFormSectionGroup 
                                                                                                                                                                                                         WHERE
                                                                                                                                                                                                            OldFormSectionGroupId = 50157
                                                                                                                                                                                                      )
,
                                                                                                                                                                                                      '5374',
                                                                                                                                                                                                      'I would like (name of person) ',
                                                                                                                                                                                                      1,
                                                                                                                                                                                                      'Y',
                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                      'N',
                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                      NULL
                                                                                                                                                                                                )
                                                                                                                                                                                                INSERT INTO
                                                                                                                                                                                                   Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                VALUES
                                                                                                                                                                                                   (
(
                                                                                                                                                                                                      SELECT
                                                                                                                                                                                                         TOP 1 NewFormSectionId 
                                                                                                                                                                                                      FROM
                                                                                                                                                                                                         @NewFormSection 
                                                                                                                                                                                                      WHERE
                                                                                                                                                                                                         OldFormSectionId = 50071),
                                                                                                                                                                                                         (
                                                                                                                                                                                                            SELECT
                                                                                                                                                                                                               TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                            FROM
                                                                                                                                                                                                               @NewFormSectionGroup 
                                                                                                                                                                                                            WHERE
                                                                                                                                                                                                               OldFormSectionGroupId = 50157
                                                                                                                                                                                                         )
,
                                                                                                                                                                                                         '5361',
                                                                                                                                                                                                         '',
                                                                                                                                                                                                         2,
                                                                                                                                                                                                         'Y',
                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                         'HelpRunMeeting',
                                                                                                                                                                                                         'N',
                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                         NULL
                                                                                                                                                                                                   )
                                                                                                                                                                                                   INSERT INTO
                                                                                                                                                                                                      Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                   VALUES
                                                                                                                                                                                                      (
(
                                                                                                                                                                                                         SELECT
                                                                                                                                                                                                            TOP 1 NewFormSectionId 
                                                                                                                                                                                                         FROM
                                                                                                                                                                                                            @NewFormSection 
                                                                                                                                                                                                         WHERE
                                                                                                                                                                                                            OldFormSectionId = 50071),
                                                                                                                                                                                                            (
                                                                                                                                                                                                               SELECT
                                                                                                                                                                                                                  TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                               FROM
                                                                                                                                                                                                                  @NewFormSectionGroup 
                                                                                                                                                                                                               WHERE
                                                                                                                                                                                                                  OldFormSectionGroupId = 50157
                                                                                                                                                                                                            )
,
                                                                                                                                                                                                            '5374',
                                                                                                                                                                                                            ' to help run my planning meeting.',
                                                                                                                                                                                                            3,
                                                                                                                                                                                                            'Y',
                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                            'N',
                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                            NULL
                                                                                                                                                                                                      )
                                                                                                                                                                                                      INSERT INTO
                                                                                                                                                                                                         Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                      VALUES
                                                                                                                                                                                                         (
(
                                                                                                                                                                                                            SELECT
                                                                                                                                                                                                               TOP 1 NewFormSectionId 
                                                                                                                                                                                                            FROM
                                                                                                                                                                                                               @NewFormSection 
                                                                                                                                                                                                            WHERE
                                                                                                                                                                                                               OldFormSectionId = 50071),
                                                                                                                                                                                                               (
                                                                                                                                                                                                                  SELECT
                                                                                                                                                                                                                     TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                  FROM
                                                                                                                                                                                                                     @NewFormSectionGroup 
                                                                                                                                                                                                                  WHERE
                                                                                                                                                                                                                     OldFormSectionGroupId = 50157
                                                                                                                                                                                                               )
,
                                                                                                                                                                                                               '5374',
                                                                                                                                                                                                               'I would like (name of person) ',
                                                                                                                                                                                                               4,
                                                                                                                                                                                                               'Y',
                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                               'N',
                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                               NULL
                                                                                                                                                                                                         )
                                                                                                                                                                                                         INSERT INTO
                                                                                                                                                                                                            Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                         VALUES
                                                                                                                                                                                                            (
(
                                                                                                                                                                                                               SELECT
                                                                                                                                                                                                                  TOP 1 NewFormSectionId 
                                                                                                                                                                                                               FROM
                                                                                                                                                                                                                  @NewFormSection 
                                                                                                                                                                                                               WHERE
                                                                                                                                                                                                                  OldFormSectionId = 50071),
                                                                                                                                                                                                                  (
                                                                                                                                                                                                                     SELECT
                                                                                                                                                                                                                        TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                     FROM
                                                                                                                                                                                                                        @NewFormSectionGroup 
                                                                                                                                                                                                                     WHERE
                                                                                                                                                                                                                        OldFormSectionGroupId = 50157
                                                                                                                                                                                                                  )
,
                                                                                                                                                                                                                  '5361',
                                                                                                                                                                                                                  '',
                                                                                                                                                                                                                  5,
                                                                                                                                                                                                                  'Y',
                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                  'TakeNotesMeeting',
                                                                                                                                                                                                                  'N',
                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                  NULL
                                                                                                                                                                                                            )
                                                                                                                                                                                                            INSERT INTO
                                                                                                                                                                                                               Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                            VALUES
                                                                                                                                                                                                               (
(
                                                                                                                                                                                                                  SELECT
                                                                                                                                                                                                                     TOP 1 NewFormSectionId 
                                                                                                                                                                                                                  FROM
                                                                                                                                                                                                                     @NewFormSection 
                                                                                                                                                                                                                  WHERE
                                                                                                                                                                                                                     OldFormSectionId = 50071),
                                                                                                                                                                                                                     (
                                                                                                                                                                                                                        SELECT
                                                                                                                                                                                                                           TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                        FROM
                                                                                                                                                                                                                           @NewFormSectionGroup 
                                                                                                                                                                                                                        WHERE
                                                                                                                                                                                                                           OldFormSectionGroupId = 50157
                                                                                                                                                                                                                     )
,
                                                                                                                                                                                                                     '5374',
                                                                                                                                                                                                                     ' to write written notes at my planning meeting.',
                                                                                                                                                                                                                     6,
                                                                                                                                                                                                                     'Y',
                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                     'N',
                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                     NULL
                                                                                                                                                                                                               )
                                                                                                                                                                                                               INSERT INTO
                                                                                                                                                                                                                  Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                               VALUES
                                                                                                                                                                                                                  (
(
                                                                                                                                                                                                                     SELECT
                                                                                                                                                                                                                        TOP 1 NewFormSectionId 
                                                                                                                                                                                                                     FROM
                                                                                                                                                                                                                        @NewFormSection 
                                                                                                                                                                                                                     WHERE
                                                                                                                                                                                                                        OldFormSectionId = 50071),
                                                                                                                                                                                                                        (
                                                                                                                                                                                                                           SELECT
                                                                                                                                                                                                                              TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                           FROM
                                                                                                                                                                                                                              @NewFormSectionGroup 
                                                                                                                                                                                                                           WHERE
                                                                                                                                                                                                                              OldFormSectionGroupId = 50158
                                                                                                                                                                                                                        )
,
                                                                                                                                                                                                                        '5361',
                                                                                                                                                                                                                        '',
                                                                                                                                                                                                                        1,
                                                                                                                                                                                                                        'Y',
                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                        'AdditionalComments2',
                                                                                                                                                                                                                        'N',
                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                        500,
                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                        NULL
                                                                                                                                                                                                                  )
                                                                                                                                                                                                                  INSERT INTO
                                                                                                                                                                                                                     Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                  VALUES
                                                                                                                                                                                                                     (
(
                                                                                                                                                                                                                        SELECT
                                                                                                                                                                                                                           TOP 1 NewFormSectionId 
                                                                                                                                                                                                                        FROM
                                                                                                                                                                                                                           @NewFormSection 
                                                                                                                                                                                                                        WHERE
                                                                                                                                                                                                                           OldFormSectionId = 50071),
                                                                                                                                                                                                                           (
                                                                                                                                                                                                                              SELECT
                                                                                                                                                                                                                                 TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                              FROM
                                                                                                                                                                                                                                 @NewFormSectionGroup 
                                                                                                                                                                                                                              WHERE
                                                                                                                                                                                                                                 OldFormSectionGroupId = 50159
                                                                                                                                                                                                                           )
,
                                                                                                                                                                                                                           '5362',
                                                                                                                                                                                                                           '',
                                                                                                                                                                                                                           1,
                                                                                                                                                                                                                           'Y',
                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                           'ChoseNotToParticipate',
                                                                                                                                                                                                                           'N',
                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                           NULL
                                                                                                                                                                                                                     )
                                                                                                                                                                                                                     INSERT INTO
                                                                                                                                                                                                                        Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                     VALUES
                                                                                                                                                                                                                        (
(
                                                                                                                                                                                                                           SELECT
                                                                                                                                                                                                                              TOP 1 NewFormSectionId 
                                                                                                                                                                                                                           FROM
                                                                                                                                                                                                                              @NewFormSection 
                                                                                                                                                                                                                           WHERE
                                                                                                                                                                                                                              OldFormSectionId = 50071),
                                                                                                                                                                                                                              (
                                                                                                                                                                                                                                 SELECT
                                                                                                                                                                                                                                    TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                 FROM
                                                                                                                                                                                                                                    @NewFormSectionGroup 
                                                                                                                                                                                                                                 WHERE
                                                                                                                                                                                                                                    OldFormSectionGroupId = 50159
                                                                                                                                                                                                                              )
,
                                                                                                                                                                                                                              '5374',
                                                                                                                                                                                                                              'Individual/Legal Guardian (as appropriate) chose not to participate in the Pre-Planning process via this format.  Information regarding customer / guardian preferences for service planning was collected in the following alternative manner and/or is found: ',
                                                                                                                                                                                                                              2,
                                                                                                                                                                                                                              'Y',
                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                              'N',
                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                              NULL
                                                                                                                                                                                                                        )
                                                                                                                                                                                                                        INSERT INTO
                                                                                                                                                                                                                           Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                        VALUES
                                                                                                                                                                                                                           (
(
                                                                                                                                                                                                                              SELECT
                                                                                                                                                                                                                                 TOP 1 NewFormSectionId 
                                                                                                                                                                                                                              FROM
                                                                                                                                                                                                                                 @NewFormSection 
                                                                                                                                                                                                                              WHERE
                                                                                                                                                                                                                                 OldFormSectionId = 50071),
                                                                                                                                                                                                                                 (
                                                                                                                                                                                                                                    SELECT
                                                                                                                                                                                                                                       TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                    FROM
                                                                                                                                                                                                                                       @NewFormSectionGroup 
                                                                                                                                                                                                                                    WHERE
                                                                                                                                                                                                                                       OldFormSectionGroupId = 50159
                                                                                                                                                                                                                                 )
,
                                                                                                                                                                                                                                 '5361',
                                                                                                                                                                                                                                 '',
                                                                                                                                                                                                                                 3,
                                                                                                                                                                                                                                 'Y',
                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                 'AlternativeManner',
                                                                                                                                                                                                                                 'N',
                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                 NULL
                                                                                                                                                                                                                           )
                                                                                                                                                                                                                           INSERT INTO
                                                                                                                                                                                                                              Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                           VALUES
                                                                                                                                                                                                                              (
(
                                                                                                                                                                                                                                 SELECT
                                                                                                                                                                                                                                    TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                 FROM
                                                                                                                                                                                                                                    @NewFormSection 
                                                                                                                                                                                                                                 WHERE
                                                                                                                                                                                                                                    OldFormSectionId = 50072),
                                                                                                                                                                                                                                    (
                                                                                                                                                                                                                                       SELECT
                                                                                                                                                                                                                                          TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                       FROM
                                                                                                                                                                                                                                          @NewFormSectionGroup 
                                                                                                                                                                                                                                       WHERE
                                                                                                                                                                                                                                          OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                    )
,
                                                                                                                                                                                                                                    '5374',
                                                                                                                                                                                                                                    'My living arrangements ',
                                                                                                                                                                                                                                    1,
                                                                                                                                                                                                                                    'Y',
                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                    'N',
                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                    NULL
                                                                                                                                                                                                                              )
                                                                                                                                                                                                                              INSERT INTO
                                                                                                                                                                                                                                 Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                              VALUES
                                                                                                                                                                                                                                 (
(
                                                                                                                                                                                                                                    SELECT
                                                                                                                                                                                                                                       TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                    FROM
                                                                                                                                                                                                                                       @NewFormSection 
                                                                                                                                                                                                                                    WHERE
                                                                                                                                                                                                                                       OldFormSectionId = 50072),
                                                                                                                                                                                                                                       (
                                                                                                                                                                                                                                          SELECT
                                                                                                                                                                                                                                             TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                          FROM
                                                                                                                                                                                                                                             @NewFormSectionGroup 
                                                                                                                                                                                                                                          WHERE
                                                                                                                                                                                                                                             OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                       )
,
                                                                                                                                                                                                                                       '5365',
                                                                                                                                                                                                                                       '',
                                                                                                                                                                                                                                       2,
                                                                                                                                                                                                                                       'Y',
                                                                                                                                                                                                                                       'RADIOYN             ',
                                                                                                                                                                                                                                       'LivingArrangements',
                                                                                                                                                                                                                                       'N',
                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                       NULL
                                                                                                                                                                                                                                 )
                                                                                                                                                                                                                                 INSERT INTO
                                                                                                                                                                                                                                    Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                 VALUES
                                                                                                                                                                                                                                    (
(
                                                                                                                                                                                                                                       SELECT
                                                                                                                                                                                                                                          TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                       FROM
                                                                                                                                                                                                                                          @NewFormSection 
                                                                                                                                                                                                                                       WHERE
                                                                                                                                                                                                                                          OldFormSectionId = 50072),
                                                                                                                                                                                                                                          (
                                                                                                                                                                                                                                             SELECT
                                                                                                                                                                                                                                                TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                             FROM
                                                                                                                                                                                                                                                @NewFormSectionGroup 
                                                                                                                                                                                                                                             WHERE
                                                                                                                                                                                                                                                OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                          )
,
                                                                                                                                                                                                                                          '5361',
                                                                                                                                                                                                                                          '',
                                                                                                                                                                                                                                          3,
                                                                                                                                                                                                                                          'Y',
                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                          'LivingArragementsComment',
                                                                                                                                                                                                                                          'N',
                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                          NULL
                                                                                                                                                                                                                                    )
                                                                                                                                                                                                                                    INSERT INTO
                                                                                                                                                                                                                                       Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                    VALUES
                                                                                                                                                                                                                                       (
(
                                                                                                                                                                                                                                          SELECT
                                                                                                                                                                                                                                             TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                          FROM
                                                                                                                                                                                                                                             @NewFormSection 
                                                                                                                                                                                                                                          WHERE
                                                                                                                                                                                                                                             OldFormSectionId = 50072),
                                                                                                                                                                                                                                             (
                                                                                                                                                                                                                                                SELECT
                                                                                                                                                                                                                                                   TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                FROM
                                                                                                                                                                                                                                                   @NewFormSectionGroup 
                                                                                                                                                                                                                                                WHERE
                                                                                                                                                                                                                                                   OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                             )
,
                                                                                                                                                                                                                                             '5374',
                                                                                                                                                                                                                                             'My relationships ',
                                                                                                                                                                                                                                             4,
                                                                                                                                                                                                                                             'Y',
                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                             'N',
                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                             NULL
                                                                                                                                                                                                                                       )
                                                                                                                                                                                                                                       INSERT INTO
                                                                                                                                                                                                                                          Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                       VALUES
                                                                                                                                                                                                                                          (
(
                                                                                                                                                                                                                                             SELECT
                                                                                                                                                                                                                                                TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                             FROM
                                                                                                                                                                                                                                                @NewFormSection 
                                                                                                                                                                                                                                             WHERE
                                                                                                                                                                                                                                                OldFormSectionId = 50072),
                                                                                                                                                                                                                                                (
                                                                                                                                                                                                                                                   SELECT
                                                                                                                                                                                                                                                      TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                   FROM
                                                                                                                                                                                                                                                      @NewFormSectionGroup 
                                                                                                                                                                                                                                                   WHERE
                                                                                                                                                                                                                                                      OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                )
,
                                                                                                                                                                                                                                                '5365',
                                                                                                                                                                                                                                                '',
                                                                                                                                                                                                                                                5,
                                                                                                                                                                                                                                                'Y',
                                                                                                                                                                                                                                                'RADIOYN             ',
                                                                                                                                                                                                                                                'MyRelationships',
                                                                                                                                                                                                                                                'N',
                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                NULL
                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                                          INSERT INTO
                                                                                                                                                                                                                                             Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                          VALUES
                                                                                                                                                                                                                                             (
(
                                                                                                                                                                                                                                                SELECT
                                                                                                                                                                                                                                                   TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                FROM
                                                                                                                                                                                                                                                   @NewFormSection 
                                                                                                                                                                                                                                                WHERE
                                                                                                                                                                                                                                                   OldFormSectionId = 50072),
                                                                                                                                                                                                                                                   (
                                                                                                                                                                                                                                                      SELECT
                                                                                                                                                                                                                                                         TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                      FROM
                                                                                                                                                                                                                                                         @NewFormSectionGroup 
                                                                                                                                                                                                                                                      WHERE
                                                                                                                                                                                                                                                         OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                   )
,
                                                                                                                                                                                                                                                   '5361',
                                                                                                                                                                                                                                                   '',
                                                                                                                                                                                                                                                   6,
                                                                                                                                                                                                                                                   'Y',
                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                   'RelationshipsComment',
                                                                                                                                                                                                                                                   'N',
                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                   NULL
                                                                                                                                                                                                                                             )
                                                                                                                                                                                                                                             INSERT INTO
                                                                                                                                                                                                                                                Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                             VALUES
                                                                                                                                                                                                                                                (
(
                                                                                                                                                                                                                                                   SELECT
                                                                                                                                                                                                                                                      TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                   FROM
                                                                                                                                                                                                                                                      @NewFormSection 
                                                                                                                                                                                                                                                   WHERE
                                                                                                                                                                                                                                                      OldFormSectionId = 50072),
                                                                                                                                                                                                                                                      (
                                                                                                                                                                                                                                                         SELECT
                                                                                                                                                                                                                                                            TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                         FROM
                                                                                                                                                                                                                                                            @NewFormSectionGroup 
                                                                                                                                                                                                                                                         WHERE
                                                                                                                                                                                                                                                            OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                      )
,
                                                                                                                                                                                                                                                      '5374',
                                                                                                                                                                                                                                                      'Community involvement / activities ',
                                                                                                                                                                                                                                                      7,
                                                                                                                                                                                                                                                      'Y',
                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                      'N',
                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                      NULL
                                                                                                                                                                                                                                                )
                                                                                                                                                                                                                                                INSERT INTO
                                                                                                                                                                                                                                                   Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                VALUES
                                                                                                                                                                                                                                                   (
(
                                                                                                                                                                                                                                                      SELECT
                                                                                                                                                                                                                                                         TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                      FROM
                                                                                                                                                                                                                                                         @NewFormSection 
                                                                                                                                                                                                                                                      WHERE
                                                                                                                                                                                                                                                         OldFormSectionId = 50072),
                                                                                                                                                                                                                                                         (
                                                                                                                                                                                                                                                            SELECT
                                                                                                                                                                                                                                                               TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                            FROM
                                                                                                                                                                                                                                                               @NewFormSectionGroup 
                                                                                                                                                                                                                                                            WHERE
                                                                                                                                                                                                                                                               OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                         )
,
                                                                                                                                                                                                                                                         '5365',
                                                                                                                                                                                                                                                         '',
                                                                                                                                                                                                                                                         8,
                                                                                                                                                                                                                                                         'Y',
                                                                                                                                                                                                                                                         'RADIOYN             ',
                                                                                                                                                                                                                                                         'CommunityInvolvment',
                                                                                                                                                                                                                                                         'N',
                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                         NULL
                                                                                                                                                                                                                                                   )
                                                                                                                                                                                                                                                   INSERT INTO
                                                                                                                                                                                                                                                      Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                   VALUES
                                                                                                                                                                                                                                                      (
(
                                                                                                                                                                                                                                                         SELECT
                                                                                                                                                                                                                                                            TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                         FROM
                                                                                                                                                                                                                                                            @NewFormSection 
                                                                                                                                                                                                                                                         WHERE
                                                                                                                                                                                                                                                            OldFormSectionId = 50072),
                                                                                                                                                                                                                                                            (
                                                                                                                                                                                                                                                               SELECT
                                                                                                                                                                                                                                                                  TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                               FROM
                                                                                                                                                                                                                                                                  @NewFormSectionGroup 
                                                                                                                                                                                                                                                               WHERE
                                                                                                                                                                                                                                                                  OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                            )
,
                                                                                                                                                                                                                                                            '5361',
                                                                                                                                                                                                                                                            '',
                                                                                                                                                                                                                                                            9,
                                                                                                                                                                                                                                                            'Y',
                                                                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                                                                            'CommunityComment',
                                                                                                                                                                                                                                                            'N',
                                                                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                                                                            NULL,
                                                                                                                                                                                                                                                            NULL
                                                                                                                                                                                                                                                      )
                                                                                                                                                                                                                                                      INSERT INTO
                                                                                                                                                                                                                                                         Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                      VALUES
                                                                                                                                                                                                                                                         (
(
                                                                                                                                                                                                                                                            SELECT
                                                                                                                                                                                                                                                               TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                            FROM
                                                                                                                                                                                                                                                               @NewFormSection 
                                                                                                                                                                                                                                                            WHERE
                                                                                                                                                                                                                                                               OldFormSectionId = 50072),
                                                                                                                                                                                                                                                               (
                                                                                                                                                                                                                                                                  SELECT
                                                                                                                                                                                                                                                                     TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                  FROM
                                                                                                                                                                                                                                                                     @NewFormSectionGroup 
                                                                                                                                                                                                                                                                  WHERE
                                                                                                                                                                                                                                                                     OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                               )
,
                                                                                                                                                                                                                                                               '5374',
                                                                                                                                                                                                                                                               'Wellness',
                                                                                                                                                                                                                                                               10,
                                                                                                                                                                                                                                                               'Y',
                                                                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                                                                               'N',
                                                                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                                                                               NULL,
                                                                                                                                                                                                                                                               NULL
                                                                                                                                                                                                                                                         )
                                                                                                                                                                                                                                                         INSERT INTO
                                                                                                                                                                                                                                                            Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                         VALUES
                                                                                                                                                                                                                                                            (
(
                                                                                                                                                                                                                                                               SELECT
                                                                                                                                                                                                                                                                  TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                               FROM
                                                                                                                                                                                                                                                                  @NewFormSection 
                                                                                                                                                                                                                                                               WHERE
                                                                                                                                                                                                                                                                  OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                  (
                                                                                                                                                                                                                                                                     SELECT
                                                                                                                                                                                                                                                                        TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                     FROM
                                                                                                                                                                                                                                                                        @NewFormSectionGroup 
                                                                                                                                                                                                                                                                     WHERE
                                                                                                                                                                                                                                                                        OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                  )
,
                                                                                                                                                                                                                                                                  '5365',
                                                                                                                                                                                                                                                                  '',
                                                                                                                                                                                                                                                                  11,
                                                                                                                                                                                                                                                                  'Y',
                                                                                                                                                                                                                                                                  'RADIOYN             ',
                                                                                                                                                                                                                                                                  'Wellness',
                                                                                                                                                                                                                                                                  'N',
                                                                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                                                                  NULL,
                                                                                                                                                                                                                                                                  NULL
                                                                                                                                                                                                                                                            )
                                                                                                                                                                                                                                                            INSERT INTO
                                                                                                                                                                                                                                                               Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                            VALUES
                                                                                                                                                                                                                                                               (
(
                                                                                                                                                                                                                                                                  SELECT
                                                                                                                                                                                                                                                                     TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                                  FROM
                                                                                                                                                                                                                                                                     @NewFormSection 
                                                                                                                                                                                                                                                                  WHERE
                                                                                                                                                                                                                                                                     OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                     (
                                                                                                                                                                                                                                                                        SELECT
                                                                                                                                                                                                                                                                           TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                        FROM
                                                                                                                                                                                                                                                                           @NewFormSectionGroup 
                                                                                                                                                                                                                                                                        WHERE
                                                                                                                                                                                                                                                                           OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                     )
,
                                                                                                                                                                                                                                                                     '5361',
                                                                                                                                                                                                                                                                     '',
                                                                                                                                                                                                                                                                     12,
                                                                                                                                                                                                                                                                     'Y',
                                                                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                                                                     'WellnessComment',
                                                                                                                                                                                                                                                                     'N',
                                                                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                                                                     NULL,
                                                                                                                                                                                                                                                                     NULL
                                                                                                                                                                                                                                                               )
                                                                                                                                                                                                                                                               INSERT INTO
                                                                                                                                                                                                                                                                  Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                               VALUES
                                                                                                                                                                                                                                                                  (
(
                                                                                                                                                                                                                                                                     SELECT
                                                                                                                                                                                                                                                                        TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                                     FROM
                                                                                                                                                                                                                                                                        @NewFormSection 
                                                                                                                                                                                                                                                                     WHERE
                                                                                                                                                                                                                                                                        OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                        (
                                                                                                                                                                                                                                                                           SELECT
                                                                                                                                                                                                                                                                              TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                           FROM
                                                                                                                                                                                                                                                                              @NewFormSectionGroup 
                                                                                                                                                                                                                                                                           WHERE
                                                                                                                                                                                                                                                                              OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                        )
,
                                                                                                                                                                                                                                                                        '5374',
                                                                                                                                                                                                                                                                        'Education',
                                                                                                                                                                                                                                                                        13,
                                                                                                                                                                                                                                                                        'Y',
                                                                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                                                                        'N',
                                                                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                                                                        NULL,
                                                                                                                                                                                                                                                                        NULL
                                                                                                                                                                                                                                                                  )
                                                                                                                                                                                                                                                                  INSERT INTO
                                                                                                                                                                                                                                                                     Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                                  VALUES
                                                                                                                                                                                                                                                                     (
(
                                                                                                                                                                                                                                                                        SELECT
                                                                                                                                                                                                                                                                           TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                                        FROM
                                                                                                                                                                                                                                                                           @NewFormSection 
                                                                                                                                                                                                                                                                        WHERE
                                                                                                                                                                                                                                                                           OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                           (
                                                                                                                                                                                                                                                                              SELECT
                                                                                                                                                                                                                                                                                 TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                              FROM
                                                                                                                                                                                                                                                                                 @NewFormSectionGroup 
                                                                                                                                                                                                                                                                              WHERE
                                                                                                                                                                                                                                                                                 OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                           )
,
                                                                                                                                                                                                                                                                           '5365',
                                                                                                                                                                                                                                                                           '',
                                                                                                                                                                                                                                                                           14,
                                                                                                                                                                                                                                                                           'Y',
                                                                                                                                                                                                                                                                           'RADIOYN             ',
                                                                                                                                                                                                                                                                           'Education',
                                                                                                                                                                                                                                                                           'N',
                                                                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                                                                           NULL,
                                                                                                                                                                                                                                                                           NULL
                                                                                                                                                                                                                                                                     )
                                                                                                                                                                                                                                                                     INSERT INTO
                                                                                                                                                                                                                                                                        Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                                     VALUES
                                                                                                                                                                                                                                                                        (
(
                                                                                                                                                                                                                                                                           SELECT
                                                                                                                                                                                                                                                                              TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                                           FROM
                                                                                                                                                                                                                                                                              @NewFormSection 
                                                                                                                                                                                                                                                                           WHERE
                                                                                                                                                                                                                                                                              OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                              (
                                                                                                                                                                                                                                                                                 SELECT
                                                                                                                                                                                                                                                                                    TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                                 FROM
                                                                                                                                                                                                                                                                                    @NewFormSectionGroup 
                                                                                                                                                                                                                                                                                 WHERE
                                                                                                                                                                                                                                                                                    OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                              )
,
                                                                                                                                                                                                                                                                              '5361',
                                                                                                                                                                                                                                                                              '',
                                                                                                                                                                                                                                                                              15,
                                                                                                                                                                                                                                                                              'Y',
                                                                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                                                                              'EducationComment',
                                                                                                                                                                                                                                                                              'N',
                                                                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                                                                              NULL,
                                                                                                                                                                                                                                                                              NULL
                                                                                                                                                                                                                                                                        )
                                                                                                                                                                                                                                                                        INSERT INTO
                                                                                                                                                                                                                                                                           Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                                        VALUES
                                                                                                                                                                                                                                                                           (
(
                                                                                                                                                                                                                                                                              SELECT
                                                                                                                                                                                                                                                                                 TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                                              FROM
                                                                                                                                                                                                                                                                                 @NewFormSection 
                                                                                                                                                                                                                                                                              WHERE
                                                                                                                                                                                                                                                                                 OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                                 (
                                                                                                                                                                                                                                                                                    SELECT
                                                                                                                                                                                                                                                                                       TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                                    FROM
                                                                                                                                                                                                                                                                                       @NewFormSectionGroup 
                                                                                                                                                                                                                                                                                    WHERE
                                                                                                                                                                                                                                                                                       OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                                 )
,
                                                                                                                                                                                                                                                                                 '5374',
                                                                                                                                                                                                                                                                                 'Employment',
                                                                                                                                                                                                                                                                                 16,
                                                                                                                                                                                                                                                                                 'Y',
                                                                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                                                                 'N',
                                                                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                                                                 NULL,
                                                                                                                                                                                                                                                                                 NULL
                                                                                                                                                                                                                                                                           )
                                                                                                                                                                                                                                                                           INSERT INTO
                                                                                                                                                                                                                                                                              Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                                           VALUES
                                                                                                                                                                                                                                                                              (
(
                                                                                                                                                                                                                                                                                 SELECT
                                                                                                                                                                                                                                                                                    TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                                                 FROM
                                                                                                                                                                                                                                                                                    @NewFormSection 
                                                                                                                                                                                                                                                                                 WHERE
                                                                                                                                                                                                                                                                                    OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                                    (
                                                                                                                                                                                                                                                                                       SELECT
                                                                                                                                                                                                                                                                                          TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                                       FROM
                                                                                                                                                                                                                                                                                          @NewFormSectionGroup 
                                                                                                                                                                                                                                                                                       WHERE
                                                                                                                                                                                                                                                                                          OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                                    )
,
                                                                                                                                                                                                                                                                                    '5365',
                                                                                                                                                                                                                                                                                    '',
                                                                                                                                                                                                                                                                                    17,
                                                                                                                                                                                                                                                                                    'Y',
                                                                                                                                                                                                                                                                                    'RADIOYN             ',
                                                                                                                                                                                                                                                                                    'Employment',
                                                                                                                                                                                                                                                                                    'N',
                                                                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                                                                    NULL,
                                                                                                                                                                                                                                                                                    NULL
                                                                                                                                                                                                                                                                              )
                                                                                                                                                                                                                                                                              INSERT INTO
                                                                                                                                                                                                                                                                                 Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                                              VALUES
                                                                                                                                                                                                                                                                                 (
                                                                                                                                                                                                                                                                         (
                                                                                                                                                                                                                                                                                    SELECT
                                                                                                                                                                                                                                                                                       TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                                                    FROM
                                                                                                                                                                                                                                                                                       @NewFormSection 
                                                                                                                                                                                                                                                                                    WHERE
                                                                                                                                                                                                                                                                                       OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                                       (
                                                                                                                                                                                                                                                                                          SELECT
                                                                                                                                                                                                                                                                                             TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                                          FROM
                                                                                                                                                                                                                                                                                             @NewFormSectionGroup 
                                                                                                                                                                                                                                                                                          WHERE
                                                                                                                                                                                                                                                                                             OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                                       )
                                                                                                                                                                                                                                                                                ,
                                                                                                                                                                                                                                                                                       '5361',
                                                                                                                                                                                                                                                                                       '',
                                                                                                                                                                                                                                                                                       18,
                                                                                                                                                                                                                                                                                       'Y',
                                                                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                                                                       'EmploymentComment',
                                                                                                                                                                                                                                                                                       'N',
                                                                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                                                                       NULL,
                                                                                                                                                                                                                                                                                       NULL
                                                                                                                                                                                                                                                                                 )
                                                                                                                                                                                                                                                                                 INSERT INTO
                                                                                                                                                                                                                                                                                    Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                                                 VALUES
                                                                                                                                                                                                                                                                                    (
                                                                                                                                                                                                                                                                       (
                                                                                                                                                                                                                                                                                       SELECT
                                                                                                                                                                                                                                                                                          TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                                                       FROM
                                                                                                                                                                                                                                                                                          @NewFormSection 
                                                                                                                                                                                                                                                                                       WHERE
                                                                                                                                                                                                                                                                                          OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                                          (
                                                                                                                                                                                                                                                                                             SELECT
                                                                                                                                                                                                                                                                                                TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                                             FROM
                                                                                                                                                                                                                                                                                                @NewFormSectionGroup 
                                                                                                                                                                                                                                                                                             WHERE
                                                                                                                                                                                                                                                                                                OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                                                                                     ,                    
                                                                                                                                                                                                                                                                                          '5374',
                                                                                                                                                                                                                                                                                          'Legal',
                                                                                                                                                                                                                                                                                          19,
                                                                                                                                                                                                                                                                                          'Y',
                                                                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                                                                          'N',
                                                                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                                                                          NULL,
                                                                                                                                                                                                                                                                                          NULL
                                                                                                                                                                                                                                                                                    )
                                                                                                                                                                                                                                                                                    INSERT INTO
                                                                                                                                                                                                                                                                                       Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                                                    VALUES
                                                                                                                                                                                                                                                                                       (
																																																																					 (
                                                                                                                                                                                                                                                                                          SELECT
                                                                                                                                                                                                                                                                                             TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                                                          FROM
                                                                                                                                                                                                                                                                                             @NewFormSection 
                                                                                                                                                                                                                                                                                          WHERE
                                                                                                                                                                                                                                                                                             OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                                             (
                                                                                                                                                                                                                                                                                                SELECT
                                                                                                                                                                                                                                                                                                   TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                                                FROM
                                                                                                                                                                                                                                                                                                   @NewFormSectionGroup 
                                                                                                                                                                                                                                                                                                WHERE
                                                                                                                                                                                                                                                                                                   OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                                             )
																																																																					  ,
                                                                                                                                                                                                                                                                                             '5365',
                                                                                                                                                                                                                                                                                             '',
                                                                                                                                                                                                                                                                                             20,
                                                                                                                                                                                                                                                                                             'Y',
                                                                                                                                                                                                                                                                                             'RADIOYN             ',
                                                                                                                                                                                                                                                                                             'Legal',
                                                                                                                                                                                                                                                                                             'N',
                                                                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                                                                             NULL,
                                                                                                                                                                                                                                                                                             NULL
                                                                                                                                                                                                                                                                                       )
                                                                                                                                                                                                                                                                                       INSERT INTO
                                                                                                                                                                                                                                                                                          Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                                                       VALUES
                                                                                                                                                                                                                                                                                          (
																																																																				 (
                                                                                                                                                                                                                                                                                             SELECT
                                                                                                                                                                                                                                                                                                TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                                                             FROM
                                                                                                                                                                                                                                                                                                @NewFormSection 
                                                                                                                                                                                                                                                                                             WHERE
                                                                                                                                                                                                                                                                                                OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                                                (
                                                                                                                                                                                                                                                                                                   SELECT
                                                                                                                                                                                                                                                                                                      TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                                                   FROM
                                                                                                                                                                                                                                                                                                      @NewFormSectionGroup 
                                                                                                                                                                                                                                                                                                   WHERE
                                                                                                                                                                                                                                                                                                      OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                                                )
																																																																					 ,
                                                                                                                                                                                                                                                                                                '5361',
                                                                                                                                                                                                                                                                                                '',
                                                                                                                                                                                                                                                                                                21,
                                                                                                                                                                                                                                                                                                'Y',
                                                                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                                                                'LegalComment',
                                                                                                                                                                                                                                                                                                'N',
                                                                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                                                                NULL,
                                                                                                                                                                                                                                                                                                NULL
                                                                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                                                                                          INSERT INTO
                                                                                                                                                                                                                                                                                             Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                                                          VALUES
                                                                                                                                                                                                                                                                                             (
																																																																					   (
                                                                                                                                                                                                                                                                                                SELECT
                                                                                                                                                                                                                                                                                                   TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                                                                FROM
                                                                                                                                                                                                                                                                                                   @NewFormSection 
                                                                                                                                                                                                                                                                                                WHERE
                                                                                                                                                                                                                                                                                                   OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                                                   (
                                                                                                                                                                                                                                                                                                      SELECT
                                                                                                                                                                                                                                                                                                         TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                                                      FROM
                                                                                                                                                                                                                                                                                                         @NewFormSectionGroup 
                                                                                                                                                                                                                                                                                                      WHERE
                                                                                                                                                                                                                                                                                                         OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                                                   )
																																																																						    ,
                                                                                                                                                                                                                                                                                                   '5374',
                                                                                                                                                                                                                                                                                                   'Other',
                                                                                                                                                                                                                                                                                                   22,
                                                                                                                                                                                                                                                                                                   'Y',
                                                                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                                                                   'N',
                                                                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                                                                   NULL,
                                                                                                                                                                                                                                                                                                   NULL
                                                                                                                                                                                                                                                                                             )
                                                                                                                                                                                                                                                                                             INSERT INTO
                                                                                                                                                                                                                                                                                                Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                                                             VALUES
                                                                                                                                                                                                                                                                                                (
																																																																						    (
                                                                                                                                                                                                                                                                                                   SELECT
                                                                                                                                                                                                                                                                                                      TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                                                                   FROM
                                                                                                                                                                                                                                                                                                      @NewFormSection 
                                                                                                                                                                                                                                                                                                   WHERE
                                                                                                                                                                                                                                                                                                      OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                                                      (
                                                                                                                                                                                                                                                                                                         SELECT
                                                                                                                                                                                                                                                                                                            TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                                                         FROM
                                                                                                                                                                                                                                                                                                            @NewFormSectionGroup 
                                                                                                                                                                                                                                                                                                         WHERE
                                                                                                                                                                                                                                                                                                            OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                                                      )
																																																																						 ,
                                                                                                                                                                                                                                                                                                      '5365',
                                                                                                                                                                                                                                                                                                      '',
                                                                                                                                                                                                                                                                                                      23,
                                                                                                                                                                                                                                                                                                      'Y',
                                                                                                                                                                                                                                                                                                      'RADIOYN             ',
                                                                                                                                                                                                                                                                                                      'Other',
                                                                                                                                                                                                                                                                                                      'N',
                                                                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                                                                      NULL,
                                                                                                                                                                                                                                                                                                      NULL
                                                                                                                                                                                                                                                                                                )
                                                                                                                                                                                                                                                                                                INSERT INTO
                                                                                                                                                                                                                                                                                                   Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                                                                                                                                                                                                                                                                                                VALUES
                                                                                                                                                                                                                                                                                                   (
																																																																						 (
                                                                                                                                                                                                                                                                                                      SELECT
                                                                                                                                                                                                                                                                                                         TOP 1 NewFormSectionId 
                                                                                                                                                                                                                                                                                                      FROM
                                                                                                                                                                                                                                                                                                         @NewFormSection 
                                                                                                                                                                                                                                                                                                      WHERE
                                                                                                                                                                                                                                                                                                         OldFormSectionId = 50072),
                                                                                                                                                                                                                                                                                                         (
                                                                                                                                                                                                                                                                                                            SELECT
                                                                                                                                                                                                                                                                                                               TOP 1 NewFormSectionGroupId 
                                                                                                                                                                                                                                                                                                            FROM
                                                                                                                                                                                                                                                                                                               @NewFormSectionGroup 
                                                                                                                                                                                                                                                                                                            WHERE
                                                                                                                                                                                                                                                                                                               OldFormSectionGroupId = 50160
                                                                                                                                                                                                                                                                                                         )
																																																																						 ,
                                                                                                                                                                                                                                                                                                         '5361',
                                                                                                                                                                                                                                                                                                         '',
                                                                                                                                                                                                                                                                                                         24,
                                                                                                                                                                                                                                                                                                         'Y',
                                                                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                                                                         'OtherComment',
                                                                                                                                                                                                                                                                                                         'N',
                                                                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                                                                         NULL,
                                                                                                                                                                                                                                                                                                         NULL
                                                                                                                                                                                                                                                                                                   )
                INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) 
                     VALUES (
						 ( SELECT  TOP 1 NewFormSectionId   FROM @NewFormSection  WHERE OldFormSectionId = 50072),
                         ( SELECT TOP 1 NewFormSectionGroupId FROM  @NewFormSectionGroup   WHERE  OldFormSectionGroupId = 50161  ),
                         '5361', '',  1,'Y', NULL,'AdditionalComments1', 'N', NULL, 500, NULL,   NULL, NULL,  NULL,  NULL,  NULL, NULL,  NULL   )
		END
        COMMIT TRANSACTION;
   END  TRY 
   BEGIN
      CATCH IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
DECLARE @ErrorMessage NVARCHAR(MAX) 
DECLARE @ErrorSeverity INT 
DECLARE @ErrorState INT 
         
	    SET  @ErrorMessage = ERROR_MESSAGE() 
        SET  @ErrorSeverity = ERROR_SEVERITY() 
        SET   @ErrorState = ERROR_STATE() RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
   END
   CATCH