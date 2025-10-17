CREATE PROCEDURE [dbo].[Hotel_UpdateReconStatus]  
-- Add the parameters for the stored procedure here  
 @id as int=0,  
 @recon varchar(1)= null,  
 @ReconBy int=0,  
 @reconRemark varchar(max)=null  
  
 AS  
BEGIN  
   
 update Hotel_BookMaster  
  set  
  ReconStatus= @recon,  
  ReconDate= GETDATE(),  
ReconBy=@ReconBy,  
ReconRemark=isnull(@reconRemark,ReconRemark)  
where   
pkId=@id  
END  