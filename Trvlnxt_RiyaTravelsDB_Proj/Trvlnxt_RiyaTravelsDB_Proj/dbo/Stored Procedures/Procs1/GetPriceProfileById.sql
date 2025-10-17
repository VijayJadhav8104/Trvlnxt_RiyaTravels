-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE PROCEDURE GetPriceProfileById    
 -- Add the parameters for the stored procedure here    
 @Id int=0    
AS    
BEGIN    
     
    select * from PricingProfile where Id=@Id and IsActive=1    
    select * from PricingProfileDetails where FKPricingProfile=@Id and IsActive=1    
    order by RowNo asc    
    
END    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPriceProfileById] TO [rt_read]
    AS [dbo];

