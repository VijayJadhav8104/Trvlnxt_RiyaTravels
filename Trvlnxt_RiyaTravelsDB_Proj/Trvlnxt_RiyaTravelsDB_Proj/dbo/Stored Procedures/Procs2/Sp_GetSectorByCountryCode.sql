-- ================================================      
-- Template generated from Template Explorer using:      
-- Create Procedure (New Menu).SQL      
-- =============================================      
-- Author:  Javed Bloch      
-- Description: to get sector  details      
-- =============================================      
create PROCEDURE [dbo].[Sp_GetSectorByCountryCode]      
@CountryCode varchar(10) 
AS      
BEGIN   
	 
 select * from sectors where [Country Code]  =@CountryCode

END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetSectorByCountryCode] TO [rt_read]
    AS [dbo];

