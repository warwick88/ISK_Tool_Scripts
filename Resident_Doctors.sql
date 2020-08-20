use ProdSmartCare

	
select * from staff
where LastName like '%Shah%'
and firstname like 'p%'

--BRamesh is 35316   -DONE
exec prodsmartcare..csp_LoadSignatureFacsimiles 35316, '\\KCMH-DB1\staffsig\Alicia1.jpg'


--Priebe is 35291
exec prodsmartcare..csp_LoadSignatureFacsimiles 35291, '\\KCMH-DB1\staffsig\GPriebe.jpg'

--Ankur Bhagat is 35305
exec prodsmartcare..csp_LoadSignatureFacsimiles 35305, '\\KCMH-DB1\staffsig\ABhagat.jpg'

--Kathleen Carter is 35293
exec prodsmartcare..csp_LoadSignatureFacsimiles 35293, '\\KCMH-DB1\staffsig\KCarter.jpg'

--P Shah
exec prodsmartcare..csp_LoadSignatureFacsimiles 35315, '\\KCMH-DB1\staffsig\PShah.jpg'






