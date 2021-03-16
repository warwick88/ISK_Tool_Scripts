/*Date--  01/27/2020
Purpose-- Update script for	Globalcode category	in General Appearance Section of Mental status Exam screen.
			Gold #22*/


IF EXISTS(SELECT 1 FROM GlobalCodes where Category='MSEGeneralAppearance' 
and CodeName='WNL- Appropriately dressed and groomed for the occasion')
BEGIN
UPDATE GlobalCodes SET ExternalCode1='G',Code='G' WHERE Category='MSEGeneralAppearance' 
and CodeName='WNL- Appropriately dressed and groomed for the occasion'
END