-- Update DocumentValidations. KCMHSAS Build Cycle Tasks #98

UPDATE DocumentValidations SET Active = 'N', ModifiedBy = 'KCMHSAS#98' , ModifiedDate=GETDATE() WHERE TableName = 'DocumentRegistrationClientRaces' AND ColumnName = 'RaceId' AND TabName = 'Demographics' AND TabOrder = 2

UPDATE DocumentValidations SET Active = 'N' , ModifiedBy = 'KCMHSAS#98' , ModifiedDate=GETDATE() WHERE TableName = 'DocumentRegistrationClientEthnicities' AND ColumnName = 'EthnicityId' AND TabName = 'Demographics' AND TabOrder = 2

