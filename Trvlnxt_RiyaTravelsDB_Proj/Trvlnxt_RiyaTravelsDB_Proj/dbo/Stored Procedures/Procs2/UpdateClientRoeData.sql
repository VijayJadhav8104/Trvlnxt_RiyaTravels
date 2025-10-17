-- =============================================  
-- Author:  <Dhanraj Bendale>  
-- Create date: <2024-09-25 16:14:08.850>  
-- Description: <Fetch Client Update>  
-- =============================================  
CREATE PROCEDURE UpdateClientRoeData  
@ROEId int,  
@UserType varchar(15),  
@OLDROE decimal(18,16),  
@newROE decimal(18,16),  
@CommandName varchar(100),  
@Response varchar(max),  
@fromCurrency varchar(3),  
@ToCurrency varchar(3),  
@AgencyID varchar(max)  
AS  
BEGIN  
   
  
 update mAgentROE set ROE=@newROE where ID =@ROEId  
  
 INSERT INTO mAgentROEHistory values(@ROEId,@UserType,@fromCurrency,@AgencyID,@ToCurrency,@OLDROE,@Response,@CommandName,GETDATE())  
  
END  