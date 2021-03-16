  --Corrected Staff PhoneNumbers.KCMHSAS Build Cycle Tasks #91 
  UPDATE Staff SET PhoneNumber = replace(replace(replace(replace(PhoneNumber, '-', ''), ')', ''), '(', ''), ' ', ''),
  OfficePhone1 = replace(replace(replace(replace(OfficePhone1, '-', ''), ')', ''), '(', ''), ' ', ''),
  OfficePhone2= replace(replace(replace(replace(OfficePhone2, '-', ''), ')', ''), '(', ''), ' ', ''),
  HomePhone= replace(replace(replace(replace(HomePhone, '-', ''), ')', ''), '(', ''), ' ', '')
