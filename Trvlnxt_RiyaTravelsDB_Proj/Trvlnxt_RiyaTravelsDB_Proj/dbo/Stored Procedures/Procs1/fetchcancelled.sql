
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[fetchcancelled] --'products@riya.travel'
	-- Add the parameters for the stored procedure here
	@pattern varchar(200)
	as
BEGIN



 select  t.pid as pid, t.PNR as PNR,min(frmloc)  as frmloc,min(toloc) as toloc,segmenttype,[Isrescheduled]
      ,[Iscancelled],
	max( [totalfare]) as totalfare,max([canceleddate]) as canceleddate,max(GDSPNR) as airlinePNR,max(airname) as airname,
min([depttime]) as depttime,max([arrivaltime]) as arrivaltime,
  min([deptdate]) as deptdate,max([arrivaldate]) as arrivaldate,[paxfname],[paxlname],
  min(t.firstvalue) as fromdest,max(t.lastvalue) as todest from 
(select bm.RiyaPNR as PNR,pm.pid,bm.segmenttype,[Isrescheduled]
      ,[Iscancelled],GDSPNR,[canceleddate],bm.airname,[totalfare] ,
first_value([frmsector]) over (partition by bm.GDSPNR order by [deptdate]) as frmloc,
last_value([tosector]) over (partition by bm.GDSPNR order by [arrivaldate] ) as toloc
,first_value([deptdate]) over (partition by bm.GDSPNR order by [deptdate]) as [deptdate],
last_value([arrivaldate]) over (partition by bm.GDSPNR order by [arrivaldate] ) as [arrivaldate]
,first_value([depttime]) over (partition by bm.GDSPNR order by [deptdate]) as [depttime],
last_value([arrivaltime]) over (partition by bm.GDSPNR order by [arrivaldate] ) as [arrivaltime]
,[paxfname],[paxlname], first_value([fromairport]) over (partition by bm.GDSPNR order by [deptdate]) as firstvalue,
            last_value([toairport]) over (partition by bm.GDSPNR order by [arrivaldate] ) as lastvalue
     from [dbo].[PassegnerMaster] pm 
	   join [dbo].[BookMaster] bm 
	  on bm.passengerid=pm.pid
	
	 -- on bm.RiyaPNR=td.riyaPNR
	 -- where
	
	 where bm.Iscancelled='HX' or bm.Iscancelled='RA'
	  --and bm.TicketNum is not null and bm.GDSPNR is not null
	-- and ( (pm.emailid =@pattern or pm.mobno=@pattern) )
	  )t
	  group by t.PNR,[paxfname],[paxlname],pid,segmenttype,[Isrescheduled]
      ,[Iscancelled]

	  order by t.pid desc
	--  ,airlinePNR,[canceleddate],airname

	  end -- order by deptdate








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchcancelled] TO [rt_read]
    AS [dbo];

