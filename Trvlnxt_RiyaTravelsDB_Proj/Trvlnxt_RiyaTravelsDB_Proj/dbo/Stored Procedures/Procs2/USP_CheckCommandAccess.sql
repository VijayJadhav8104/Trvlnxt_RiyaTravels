-- =============================================    
-- Author:  <DHANRAJ BENDALE>    
-- Create date: <14/06/2023>    
-- Description: <Command access as per user only riya staff>    
-- =============================================    
CREATE PROCEDURE USP_CheckCommandAccess    
 @CommandName varchar(100),    
 @UserId varchar(50),    
 @VendorName varchar(20),    
 @OfficeId varchar(20)    
AS    
BEGIN    
 if exists(select * from tblCrpticCommandAccess     
 where OfficeId=@OfficeId and CommandName=@CommandName    
 and VendorName=@VendorName and AgentId=@UserId)    
 BEGIN    
   select 1    
 END    
 ELSE select 0    
     
END 