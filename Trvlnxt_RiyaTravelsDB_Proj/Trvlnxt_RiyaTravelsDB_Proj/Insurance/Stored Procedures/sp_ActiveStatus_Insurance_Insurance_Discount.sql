
    
-- =============================================    
-- Author:  <Abhishek Varankar>    
-- Create date: <20-March-2024>    
-- Description: <updates IsActive status>    
-- =============================================    
CREATE PROCEDURE [Insurance].[sp_ActiveStatus_Insurance_Insurance_Discount]    
@id int=null,    
@flag varchar(20)=null    
AS    
BEGIN    
 if(@flag='Active')    
 begin    
  update [Insurance].[tbl_Insurance_Discount] set isActive=1 where Id=@id    
 end    
    
 else if(@flag='Deactive')    
 begin    
  update [Insurance].[tbl_Insurance_Discount] set isActive=0 where Id=@id    
 end    
    
END    
    
