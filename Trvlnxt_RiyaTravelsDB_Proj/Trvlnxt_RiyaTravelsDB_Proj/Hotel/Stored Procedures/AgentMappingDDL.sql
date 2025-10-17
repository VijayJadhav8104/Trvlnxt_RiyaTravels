CREATE PROCEDURE Hotel.AgentMappingDDL                                    
 -- Add the parameters for the stored procedure here                                    
                                     
AS                                    
BEGIN                                    
                                  
 SET NOCOUNT ON;                                                     
                                     
        
        
 --=Country--                                 
select CountryCode,CountryName  from CountryMaster        
    
--UserType --    
    
select  ID,[Value] as 'UserType'  from mCommon where Category='UserType'     
       
 --Supplier --    
 select id,SupplierName from B2BHotelSupplierMaster     
    
 -- Pricing Profile --    
 select id,ProfileName  from PricingProfile     
    
END         
        
        
        