-- ================================================      
-- Template generated from Template Explorer using:      
-- Create Procedure (New Menu).SQL      
-- =============================================      
-- Author:  Javed Bloch      
-- Description: to get erpcountry  details      
-- =============================================      
CREATE PROCEDURE [dbo].[Sp_GetErpCountryByOfficeId]      
@OfficeId varchar(50) = NULL
AS      
BEGIN   

	select Value from mVendorCredential where
OfficeId=@OfficeId and FieldName='ERP Country'


END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetErpCountryByOfficeId] TO [rt_read]
    AS [dbo];

