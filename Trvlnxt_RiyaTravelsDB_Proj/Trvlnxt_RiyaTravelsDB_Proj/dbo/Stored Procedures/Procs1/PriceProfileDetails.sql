  
CREATE PROCEDURE PriceProfileDetails     
 -- Add the parameters for the stored procedure here    
 @Id int=0    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
   select * from PricingProfile where Id=@Id    
   select * from PricingProfileDetails where FKPricingProfile=@Id    and IsActive=1
   order by RowNo asc    
    
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[PriceProfileDetails] TO [rt_read]
    AS [dbo];

