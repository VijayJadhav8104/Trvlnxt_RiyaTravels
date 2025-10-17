        
-- =============================================        
-- Author:  <sana>        
-- Create date: <18-May-2022>        
-- Description: <updates IsActive status>        
-- =============================================        
CREATE PROCEDURE [SS].sp_ActiveStatus_Cancellation      
@id int=null,        
@flag varchar(20)=null        
AS        
BEGIN        
 if(@flag='Active')        
 begin        
  update [SS].tbl_Cancellation set isActive=1 where Pkid=@id        
 end        
        
 else if(@flag='Deactive')        
 begin        
  update [SS].tbl_Cancellation set isActive=0 where Pkid=@id        
 end        
        
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[SS].[sp_ActiveStatus_Cancellation] TO [rt_read]
    AS [DB_TEST];

