-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE PROCEDURE BBHotelAPIUser    
     
 @GroupName varchar(100)=null,    
 @AgentIcust varchar(100)=null,    
 @CompanyName varchar(100)=null,    
 @ClientName varchar(100)=null,    
 @Username varchar(100)=null,    
 @password varchar(100)=null,    
 @Ip varchar(100)=null,    
 @CreatedBy int=0,    
 @Action varchar(100)=null,    
 @FkId int=0    
AS    
BEGIN    
     
 DECLARE @ScopeId int=0;    
    
 if(@Action='AddGroup')    
 begin    
 if not exists(select Name from HotelApiClients where Name=@GroupName and Status=1)    
  begin    
   insert into HotelApiClients (Name,AgentId)    
   values(@GroupName,@AgentIcust)    
   select SCOPE_IDENTITY()    
  end    
 else    
  begin    
   select 'Exists Data';    
  end    
 end    
    
 if(@Action='AddCompany')    
 begin    
     
   insert into HotelApiClientsCompany (ClientId,    
            CompanyName,    
            CompanyUsername,    
            CompanyPassword,    
            CreatedBy)    
    
            values(@FkId,    
            @CompanyName,    
            @Username,    
            @password,    
            @CreatedBy)    
   select SCOPE_IDENTITY()    
 end    
     
 if(@Action='GetData')    
 begin    
   SELECT C.Id,    
           C.Name,    
        C.Status,    
           c.CreatedDate,    
        m.FullName as CreatedBy,    
        AL.AgencyName AS AgentName     
    
    FROM  HotelApiClients C     
    INNER JOIN B2BRegistration AL ON AL.PKID=C.AgentId     
    inner join mUser m on c.CreatedBy=m.ID    
    WHERE C.IsDeleted is null;    
 end    
    
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[BBHotelAPIUser] TO [rt_read]
    AS [dbo];

