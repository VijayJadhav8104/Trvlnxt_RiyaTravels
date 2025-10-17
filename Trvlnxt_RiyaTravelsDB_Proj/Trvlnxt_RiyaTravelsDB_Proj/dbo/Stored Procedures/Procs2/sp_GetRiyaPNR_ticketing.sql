        
-- =============================================        
-- Author:  Pradeep Pandey        
-- Create date: 07 july 2020        
-- Description: To get Riya PNR        
-- =============================================        
CREATE PROCEDURE [dbo].[sp_GetRiyaPNR_ticketing]         
 -- Add the parameters for the stored procedure here        
 @GDSPNR VARCHAR(10)      
 ,@depFrom varchar(10) = null              
 ,@depTo varchar(10) = null    
 ,@orderId varchar(50) = null  
 ,@fName varchar(50) = null  
 ,@lName varchar(50) = null  
AS        
BEGIN        
 -- SET NOCOUNT ON added to prevent extra result sets from        
 -- interfering with SELECT statements.        
 SET NOCOUNT ON;        
        
    if @depFrom != '' and @depFrom != 'null'      
   begin      
  select top 1 BM.riyaPNR from tblBookItenary BI 
  inner join tblBookMaster BM ON BM.orderId = BI.orderId
  inner join tblPassengerBookDetails PB on BM.pkId = PB.fkBookMaster
  where BI.frmSector = @depFrom and BI.toSector = @depTo and BM.GDSPNR = @GDSPNR
  and PB.paxFName = @fName and PB.paxLName = @lName
   end   
 END 