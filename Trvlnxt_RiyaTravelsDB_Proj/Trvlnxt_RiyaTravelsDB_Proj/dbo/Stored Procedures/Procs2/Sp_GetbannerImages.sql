CREATE Procedure Sp_GetbannerImages
@UserType nvarchar(20),
@AgentCountry  nvarchar(20),
@AgentID nvarchar(10)
as
begin

select 
m2.ImageByte as imagedata,
m1.AgencyId as AgentID,m2.ModifiedOn, m2.ImageOrder
,m1.FromDateTime
,m1.ToDateTime
,m1.id
,m2.URL
from mbanner m1
inner join mBannerImages m2 on m2.BannerId=m1.ID
where m1.UserType IN (
     SELECT t.c.value('.', 'VARCHAR(20)')
     FROM (
         SELECT x = CAST('<t>' + 
               REPLACE(@UserType, ',', '</t><t>') + '</t>' AS XML)
     ) a
     CROSS APPLY x.nodes('/t') t(c)) 

and m1.Country IN (
     SELECT t.c.value('.', 'VARCHAR(20)')
     FROM (
         SELECT x = CAST('<t>' + 
               REPLACE(@AgentCountry, ',', '</t><t>') + '</t>' AS XML)
     ) a
     CROSS APPLY x.nodes('/t') t(c)) 

and (m1.AgencyId=@AgentID or m1.AgencyId='All') 
and Product='Airline'

and (
(m1.FromDateTime <= getdate() AND m1.ToDateTime >= getdate())
OR (m1.FromDateTime is Null) OR (m1.ToDateTime is Null)
)
and m1.IsActive=1 and m2.IsActive=1
order by m2.ImageOrder asc

end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetbannerImages] TO [rt_read]
    AS [dbo];

