    
-- =============================================    
-- Author:  <sana>    
-- Create date: <18-May-2022>    
-- Description: <updates IsActive status>    
-- =============================================    
CREATE PROCEDURE [ER].sp_ActiveStatus_ServiceFee  
@id int=null,    
@flag varchar(20)=null    
AS    
BEGIN    
 if(@flag='Active')    
 begin    
  update [ER].[tbl_ServiceFee] set isActive=1 where Id=@id    
 end    
    
 else if(@flag='Deactive')    
 begin    
  update [ER].[tbl_ServiceFee] set isActive=0 where Id=@id    
 end    
    
END    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[ER].[sp_ActiveStatus_ServiceFee] TO [rt_read]
    AS [RiyaTravels];

