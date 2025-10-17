  
    
    
    
CREATE PROCEDURE [Hotel].HotelAttributeList                                
 -- Add the parameters for the stored procedure here                                
                                 
AS                                
BEGIN                                
                              
 SET NOCOUNT ON;                                                 
                                
select * from hotel.[mAttributes_Hotel] where IsActive=1    
    
END       