-- =============================================    
-- Author:Gaurav Pandey    
-- Create date: 03-Aug-2022    
-- Description: Procedure is created for Getting Conversion of Roe   
   
-- =============================================    
CREATE PROCEDURE [dbo].[Get_RoeConversionforallCurrency]    
 -- Add the parameters for the stored procedure here    
 @Currency varchar(50),
 @BaseCurrency varchar (50)
AS    
BEGIN    
    
   
 select SUM(RO.ROE+ISNULL(BBR.Markup,0)) as ROE from roe RO

 LEFT JOIN BBHotelROEWithMarkup BBR ON RO.ToCur = BBR.FromCurrency AND BBR.ToCurrency = @currency AND BBR.IsActive=1

 where FromCur=@currency and ToCur =@basecurrency AND RO.ISACTIVE = 1 
 
 END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_RoeConversionforallCurrency] TO [rt_read]
    AS [dbo];

