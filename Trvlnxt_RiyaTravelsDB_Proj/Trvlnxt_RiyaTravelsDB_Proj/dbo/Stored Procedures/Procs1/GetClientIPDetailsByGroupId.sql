--sp_HelpText GetClientIPDetailsByGroupId        
        
        
        
CREATE PROC GetClientIPDetailsByGroupId        
 @Id INT        
 AS        
 BEGIN        
 SELECT Id,Name,CreatedDate,HAC.Status,CreatedBy,AgentId,Icast +' - '+AgencyName  as AgencyName,Product,HAC.FKUserID FROM HotelApiClients HAC       
 left join B2BRegistration BR on HAC.AgentId=BR.PKID      
 WHERE Id=@Id AND IsDeleted IS NULL;        
      
 SELECT C.Id AS ClientUserId,C.ClientId,C.CompanyName,C.CompanyUsername,C.CompanyPassword,C.ClientNumber        
 FROM HotelApiClientsCompany C  WHERE C.ClientId=@Id AND C.Status=1;        
      
      
 SELECT * FROM HotelApiClientsIPs WHERE ClientCompanyId IN(SELECT Id FROM HotelApiClientsCompany WHERE ClientId=@Id and Status=1) AND Status=1 order by ClientCompanyId;        
 END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetClientIPDetailsByGroupId] TO [rt_read]
    AS [dbo];

