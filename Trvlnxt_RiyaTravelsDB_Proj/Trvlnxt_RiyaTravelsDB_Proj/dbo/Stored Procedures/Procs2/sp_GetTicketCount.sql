CREATE PROCEDURE [dbo].[sp_GetTicketCount]
-- Add the parameters for the stored procedure here
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

    -- Insert statements for procedure here

select AgentID as UserType, case when Country='IN' THEN 'INDIA'
WHEN  Country='US' THEN 'USA' when Country='CA' THEN 'CANADA' when Country='AE' THEN 'UAE' END AS Customer,count(fkBookMaster) as [No Of Tickets],cast(cast(round(sum(tpbd.totalFare*tbm.ROE),0) as int) as varchar(50) ) + ' INR' as [Total sale] from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster --and tpbd.isReturn=0
where Country='IN'and AgentID='B2C' and  tbm.totalFare>0 and tpbd.totalFare>0 AND IsBooked=1 and convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by AgentID,Country

UNION

select AgentID as UserType,case when Country='IN' THEN 'INDIA'
WHEN  Country='US' THEN 'USA' when Country='CA' THEN 'CANADA' when Country='AE' THEN 'UAE' END AS Customer,count(fkBookMaster)  as [No Of Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' INR' as [Total sale]  from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster-- and tpbd.isReturn=0
where Country='US'and AgentID='B2C' AND IsBooked=1 and  tbm.totalFare>0 and tpbd.totalFare>0 and convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by AgentID,Country

UNION

select AgentID as UserType,case when Country='IN' THEN 'INDIA'
WHEN  Country='US' THEN 'USA' when Country='CA' THEN 'CANADA' when Country='AE' THEN 'UAE' END AS Customer,count(fkBookMaster) as [No Of Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' INR' as [Total sale]  from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster --and tpbd.isReturn=0
where Country='CA'and AgentID='B2C' AND IsBooked=1 and  tbm.totalFare>0 and tpbd.totalFare>0 and convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by AgentID,Country

UNION

select 'B2B' as UserType,case when tbm.Country='IN' THEN 'INDIA'
WHEN  tbm.Country='US' THEN 'USA' when tbm.Country='CA' THEN 'CANADA' when tbm.Country='AE' THEN 'UAE' END AS Customer,count(fkBookMaster)  as [No Of Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' CAD' as [Total sale]  from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster
inner join agentLogin AL ON AL.UserID=tbm.AgentID 
where TBM.Country='CA'and AL.userTypeID=2 AND IsBooked=1 and  tbm.totalFare>0 and tpbd.totalFare>0 and 
convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by TBM.Country

UNION

select 'B2B' as UserType,case when tbm.Country='IN' THEN 'INDIA'
WHEN  tbm.Country='US' THEN 'USA' when tbm.Country='CA' THEN 'CANADA' when tbm.Country='AE' THEN 'UAE' END AS Customer,count(fkBookMaster)  as [No Of Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' USD' as [Total sale]  from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster
inner join agentLogin AL ON AL.UserID=tbm.AgentID 
where TBM.Country='US'and AL.userTypeID=2 and  tbm.totalFare>0 and tpbd.totalFare>0
AND IsBooked=1 and convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by TBM.Country


UNION

select 'B2B' as UserType,case when tbm.Country='IN' THEN 'INDIA'
WHEN  tbm.Country='US' THEN 'USA' when tbm.Country='CA' THEN 'CANADA' when tbm.Country='AE' THEN 'UAE' END AS Customer,count(fkBookMaster)  as [No Of Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' AED' as [Total sale]  from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster
inner join agentLogin AL ON AL.UserID=tbm.AgentID 
where TBM.Country='AE'and AL.userTypeID=2 AND IsBooked=1 and  tbm.totalFare>0 and tpbd.totalFare>0 and 
convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by TBM.Country

UNION

select 'B2B' as UserType,case when tbm.Country='IN' THEN 'INDIA'
WHEN  tbm.Country='US' THEN 'USA' when tbm.Country='CA' THEN 'CANADA' when tbm.Country='AE' THEN 'UAE' END AS Customer,count(fkBookMaster) as [No Of Tickets],
cast(cast(round(sum(tpbd.totalFare*tbm.ROE),0) as int) as varchar(50) ) + ' INR' as [Total sale]  from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster
inner join agentLogin AL ON AL.UserID=tbm.AgentID AND tbm.AgentID!='B2C'
where TBM.Country='IN'and AL.userTypeID=2 AND IsBooked=1 and  tbm.totalFare>0 and tpbd.totalFare>0 and convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by TBM.Country


UNION

select 'HOLIDAY' as UserType,case when tbm.Country='IN' THEN 'INDIA'
WHEN  tbm.Country='US' THEN 'USA' when tbm.Country='CA' THEN 'CANADA' when tbm.Country='AE' THEN 'UAE' END AS Customer,count(fkBookMaster)  as [No Of Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' INR' as [Total sale]  from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster
inner join agentLogin AL ON AL.UserID=tbm.AgentID  AND tbm.AgentID!='B2C'
where TBM.Country='IN'and AL.userTypeID=4 AND IsBooked=1 and  tbm.totalFare>0 and tpbd.totalFare>0 and convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by TBM.Country

UNION

select 'MARINE' as UserType,case when tbm.Country='IN' THEN 'INDIA'
WHEN  tbm.Country='US' THEN 'USA' when tbm.Country='CA' THEN 'CANADA' when tbm.Country='AE' THEN 'UAE' END AS Customer,count(fkBookMaster)  as [No Of Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' INR' as [Total sale]  from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster
inner join agentLogin AL ON AL.UserID=tbm.AgentID AND tbm.AgentID!='B2C'
where TBM.Country='IN'and AL.userTypeID=3 AND IsBooked=1 and  tbm.totalFare>0 and tpbd.totalFare>0 and convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by TBM.Country


UNION

select 'MARINE' as UserType,case when tbm.Country='IN' THEN 'INDIA'
WHEN  tbm.Country='US' THEN 'USA' when tbm.Country='CA' THEN 'CANADA' when tbm.Country='AE' THEN 'UAE' END AS Customer,count(fkBookMaster)  as [No Of Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' AED' as [Total sale]  from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster
inner join agentLogin AL ON AL.UserID=tbm.AgentID 
where TBM.Country='AE'and AL.userTypeID=3 AND IsBooked=1 and  tbm.totalFare>0 and tpbd.totalFare>0 and 
convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by TBM.Country

UNION

select 'RBT' as UserType,case when tbm.Country='IN' THEN 'INDIA'
WHEN  tbm.Country='US' THEN 'USA' when tbm.Country='CA' THEN 'CANADA' when tbm.Country='AE' THEN 'UAE' END AS Customer,count(fkBookMaster)  as [No Of Tickets],
cast(cast(round(sum(tpbd.totalFare),0) as int) as varchar(50) ) + ' USD' as [Total sale]  from tblBookMaster tbm
inner join tblPassengerBookDetails tpbd on tbm.pkid=tpbd.fkBookMaster
inner join agentLogin AL ON AL.UserID=tbm.AgentID AND tbm.AgentID!='B2C'
where TBM.Country='US'and AL.userTypeID=5 AND IsBooked=1 and  tbm.totalFare>0 and tpbd.totalFare>0 and 
convert(varchar(12),tbm.inserteddate,102) = convert(varchar(12),Getdate()-1,102)
Group by TBM.Country

UNION

select 'MARINECORP' as UserType,case when tbm.Country='IN' THEN 'INDIA'
WHEN  tbm.Country='US' THEN 'USA' when tbm.Country='CA' THEN 'CANADA' when tbm.Country='AE' THEN 'UAE' END AS Customer,count(tpbd.FkFlightInfoID)  as [No Of Tickets],
cast(cast(round(sum(tbm.totalFare),0) as int) as varchar(50) ) + ' INR' as [Total sale]  from  MarineTool.dbo.txnBookFlightInfo tbm
inner join MarineTool.dbo.txnBookPaxInfo tpbd on tbm.id=tpbd.FkFlightInfoID
inner join MarineTool.dbo.txnBookClassInfo pi on pi.FkFlightInfoID  = tbm.ID and pi.FkPaxID = tpbd.ID
inner join MarineTool.dbo.mCorporate AL ON AL.id=tbm.Corporate_Code 
--AND tbm.UserType!='B2C'
where TBM.Country='IN'
and AL.User_Type='MN'
AND IsBooked=1 and pi.totalFare>0 and convert(varchar(12),tbm.Created_Date,102) = convert(varchar(12),Getdate()-1,102)
Group by TBM.Country


end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetTicketCount] TO [rt_read]
    AS [dbo];

