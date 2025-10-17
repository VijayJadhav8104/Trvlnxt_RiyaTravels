--GetAPIAuthMaster '',0,0,0      
CREATE PROC FetchAllBlockStatus      
  
AS      
BEGIN      
 SET NOCOUNT ON;      
select distinct allblock from APIAuthenticationMaster  
        
END 