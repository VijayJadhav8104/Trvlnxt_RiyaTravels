 CREATE procedure [dbo].[GetDyanamicPricingDetails]    
    
  @IsActive bit,  
  @VendorName varchar(50)  
as    
begin    
 select UserType,AgentCountry,VendorName from DyanamicPricingDetails   
 where IsActive= @IsActive and VendorName = @VendorName  
end