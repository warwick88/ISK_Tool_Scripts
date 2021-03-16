 /*********************************************************************/                                                                   
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                    
/* Creation Date:    12/3/2020                                        */                                                                    
/*                                                                   */                                                                    
/* Purpose:used in  client services report           */                                                      
 /*  Date           Alter By			Purpose                             */                                                                    
 /* 12 Dec , 2020   Sunil Dasari		What: Removed the  CRAFFT validations when Child type of assessment selected.
										Why: In PREPROD we are having issues on the assessment where the ASAM is being required for kids (even when child is selected, and CRAFFT is not applicable). 
									    KCMHSAS Build Cycle Tasks #116
 */                                           
/*********************************************************************/   
  
update documentvalidations set Active='N' where DocumentCodeId=1469  and ColumnName='Dimension1LevelOfCare' and TabName='Crafft' and Active='Y'
update documentvalidations set Active='N' where DocumentCodeId=1469  and ColumnName='Dimension2LevelOfCare' and TabName='Crafft' and Active='Y'
update documentvalidations set Active='N' where DocumentCodeId=1469  and ColumnName='Dimension3LevelOfCare' and TabName='Crafft' and Active='Y'
update documentvalidations set Active='N' where DocumentCodeId=1469  and ColumnName='Dimension4LevelOfCare' and TabName='Crafft' and Active='Y'
update documentvalidations set Active='N' where DocumentCodeId=1469  and ColumnName='Dimension5LevelOfCare' and TabName='Crafft' and Active='Y'
update documentvalidations set Active='N' where DocumentCodeId=1469  and ColumnName='Dimension6LevelOfCare' and TabName='Crafft' and Active='Y'