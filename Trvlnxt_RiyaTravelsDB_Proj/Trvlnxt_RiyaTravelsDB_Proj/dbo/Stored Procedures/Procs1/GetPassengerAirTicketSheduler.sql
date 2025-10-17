-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE GetPassengerAirTicketSheduler  
@fkBookMaster varchar(30)   
AS  
BEGIN  
 select * from tblPassengerBookDetails where fkBookMaster=@fkBookMaster  
END  