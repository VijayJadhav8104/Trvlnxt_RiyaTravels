CREATE PROCEDURE [dbo].[sp_GetTicketCount1]
-- Add the parameters for the stored procedure here
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

    -- Insert statements for procedure here

select AgentID as UserType,Country,count(fkBookMaster) as [No OF Tickets],cast(cast(round(sum(tpbd.totalFare*tbm.ROE),0) as int) as varchar(50) ) + ' INR' as [Sum Of Total Fare] from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster --and tpbd.isReturn=0
where Country='IN'and AgentID='B2C' AND IsBooked=1 and convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by AgentID,Country

UNION

select AgentID as UserType,Country,count(fkBookMaster) as [No OF Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' INR' as [Sum Of Total Fare] from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster-- and tpbd.isReturn=0
where Country='US'and AgentID='B2C' AND IsBooked=1 and convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by AgentID,Country

UNION

select AgentID as UserType,Country,count(fkBookMaster) as [No OF Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' INR' as [Sum Of Total Fare] from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster --and tpbd.isReturn=0
where Country='CA'and AgentID='B2C' AND IsBooked=1 and convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by AgentID,Country

UNION

select 'B2B' as UserType,Country,count(fkBookMaster) as [No OF Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' CAD' as [Sum Of Total Fare] from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster --and tpbd.isReturn=0
where Country='CA'and AgentID<>'B2C' AND IsBooked=1 and convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by Country

UNION

select 'B2B' as UserType,Country,count(fkBookMaster) as [No OF Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' USD' as [Sum Of Total Fare] from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster --and tpbd.isReturn=0
where Country='US'and AgentID<>'B2C' AND IsBooked=1 and convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by Country

UNION

select 'B2B' as UserType,Country,count(fkBookMaster) as [No OF Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' AED' as [Sum Of Total Fare] from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster --and tpbd.isReturn=0
where Country='AE'and AgentID='B2B' AND IsBooked=1 and convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by Country
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetTicketCount1] TO [rt_read]
    AS [dbo];

