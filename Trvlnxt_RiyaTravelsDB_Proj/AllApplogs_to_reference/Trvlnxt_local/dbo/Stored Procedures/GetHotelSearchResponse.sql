  
-- =============================================  
-- Author:  Akash singh  
-- Create date:25/01/2022  
-- Description: this sp used for perticular Hotel search response to rectify issue   
-- =============================================  
CREATE PROCEDURE [dbo].[GetHotelSearchResponse]   
@Id int   
AS  
BEGIN  
 select Api_Response from [StoreLogs].HotelB2BRequestResponseLogs where Id=@Id  
END  

