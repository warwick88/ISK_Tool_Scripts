  -- Task Details	KCMHSAS - Enhancements ,66   


SET IDENTITY_INSERT [dbo].[DEImportExportDocumentFormats] ON 
GO
IF NOT EXISTS (SELECT 1 FROM DEImportExportDocumentFormats WHERE DEImportExportDocumentFormatId=1 )				
BEGIN
INSERT INTO [dbo].[DEImportExportDocumentFormats] ([DEImportExportDocumentFormatId], [CreatedDate], [FromDEOrganizationId], [ToDEOrganizationId], [DocumentFormat], [StoredProcedureName], [CentralTransferDocumentTypeId]) VALUES (1, GETDATE(), 3, 1, 8247, N'csp_ProcessIncomingClientHealthAttributesXML', 1052)
END
GO
SET IDENTITY_INSERT [dbo].[DEImportExportDocumentFormats] OFF
GO
