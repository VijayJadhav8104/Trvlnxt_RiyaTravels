        
-- =============================================        
-- Author:  <sana>        
-- Create date: <18-May-2022>        
-- Description: <updates IsActive status>        
-- =============================================        
CREATE PROCEDURE [ER].sp_ActiveStatus_Cancellation      
@id int=null,        
@flag varchar(20)=null        
AS        
BEGIN        
 if(@flag='Active')        
 begin        
  update [ER].[tbl_Cancellation] set isActive=1 where Pkid=@id        
 end        
        
 else if(@flag='Deactive')        
 begin        
  update [ER].[tbl_Cancellation] set isActive=0 where Pkid=@id        
 end        
        
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[ER].[sp_ActiveStatus_Cancellation] TO [rt_read]
    AS [RiyaTravels];

