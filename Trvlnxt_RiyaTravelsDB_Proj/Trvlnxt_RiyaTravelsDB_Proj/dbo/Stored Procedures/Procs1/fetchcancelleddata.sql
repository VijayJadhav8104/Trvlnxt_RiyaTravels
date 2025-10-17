
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[fetchcancelleddata] --'products@riya.travel'
	-- Add the parameters for the stored procedure here
	@pattern varchar(200)
	as
BEGIN
select t.PNR as PNR,
t.pid as pid,min(frmloc)  as frmloc,min(toloc) as toloc,OrderId,
min([depttime]) as depttime,max([arrivaltime]) as arrivaltime,
  min([deptdate]) as deptdate,max([arrivaldate]) as arrivaldate,segmenttype,
  [paxfname],[paxlname],min(t.firstvalue) as fromdest,max(t.lastvalue) as todest from 
(select bm.GDSPNR as PNR,pm.pid,segmenttype,OrderId,
first_value([frmsector]) over (partition by bm.GDSPNR order by [deptdate]) as frmloc,
last_value([tosector]) over (partition by bm.GDSPNR order by [arrivaldate] ) as toloc
,first_value([deptdate]) over (partition by bm.GDSPNR order by [deptdate]) as [deptdate],
last_value([arrivaldate]) over (partition by bm.GDSPNR order by [arrivaldate] ) as [arrivaldate]
,first_value([depttime]) over (partition by bm.GDSPNR order by [deptdate]) as [depttime],
last_value([arrivaltime]) over (partition by bm.GDSPNR order by [arrivaldate] ) as [arrivaltime]
,[paxfname],[paxlname], first_value([fromairport]) over (partition by bm.RiyaPNR order by [deptdate]) as firstvalue,
            last_value([toairport]) over (partition by bm.GDSPNR order by [arrivaldate] ) as lastvalue
     from [dbo].[PassegnerMaster] pm 
	  join [dbo].[BookMaster] bm 
	  on bm.passengerid=pm.pid
	  where (pm.emailid =@pattern or pm.mobno=@pattern or @pattern='')
	and bm.Iscancelled='HX'
	  and bm.arrivaldate>=GETDATE()
	  and bm.TicketNum is not null and bm.GDSPNR is not null
	 
	  )t
	  group by t.PNR,[paxfname],[paxlname],pid,segmenttype,OrderId

end








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchcancelleddata] TO [rt_read]
    AS [dbo];

