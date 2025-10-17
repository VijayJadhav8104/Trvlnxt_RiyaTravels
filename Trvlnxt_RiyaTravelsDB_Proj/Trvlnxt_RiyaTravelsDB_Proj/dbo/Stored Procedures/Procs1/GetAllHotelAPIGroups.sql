CREATE PROC GetAllHotelAPIGroups      
 AS      
 BEGIN       
      
    SELECT C.Id,      
           C.Name,      
        C.Status,      
           c.CreatedDate,      
        m.FullName as CreatedBy,      
        AL.AgencyName AS AgentName       
      
    FROM  HotelApiClients C       
    left JOIN B2BRegistration AL ON AL.PKID=C.AgentId       
    left join mUser m on c.CreatedBy=m.ID      
    WHERE C.IsDeleted IS NULL;      
      
  --SELECT C.Id,C.Name,C.Status,      
  --  (AL.FirstName+' '+ISNULL(AL.LastName,'')) AS AgentName       
  --  FROM        
  --  HotelApiClients C INNER JOIN AgentLogin AL      
  --ON AL.UserID=C.AgentId WHERE C.IsDeleted IS NULL;      
 END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllHotelAPIGroups] TO [rt_read]
    AS [dbo];

