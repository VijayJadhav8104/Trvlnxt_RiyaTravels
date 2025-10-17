
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[fetchRefundTkt] --'products@riya.travel'
	
	as
BEGIN



 select t.PNR as PNR,t.pid as pid,min(frmloc)  as frmloc,min(toloc) as toloc,segmenttype,[Isrescheduled] ,[Iscancelled]
 ,max([totalfare]) as totalfare
 ,max(servicecharge) as servicecharge,max([cancellationpanelty]) as cancellationpanelty,
 max([cancellationremark]) as cancellationremark,max ([updated_by] ) as updated_by--ashvini
     ,max([canceleddate]) as canceleddate,max(GDSPNR) as airlinePNR ,max(airname) as airname,
min([depttime]) as depttime,max([arrivaltime]) as arrivaltime,
  min([deptdate]) as deptdate,max([arrivaldate]) as arrivaldate,[paxfname],[paxlname],min(t.firstvalue) as fromdest,min(t.lastvalue) as todest from 
(select bm.RiyaPNR as PNR,pm.pid,bm.segmenttype,[Isrescheduled]
      ,[Iscancelled],GDSPNR,[canceleddate],bm.airname,[totalfare],servicecharge,[cancellationpanelty],[cancellationremark],upper(ams.UserName) as  [updated_by],
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
	  on pm.[pid]=bm.passengerid
	  join [dbo].[adminMaster] ams
	  on ams.id=bm.updated_by
	
	 -- on bm.RiyaPNR=td.riyaPNR
	 -- where
	
	 where bm.Iscancelled='CN'

	  )t
	  group by t.PNR,[paxfname],[paxlname],pid,segmenttype,[Isrescheduled],GDSPNR
      ,[Iscancelled],canceleddate
	  order by t.canceleddate desc
	--,[canceleddate],airname,[totalfare]  ,servicecharge,[cancellationpanelty],[cancellationremark],[updated_by] --ashvini
	  end -- order by deptdate








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchRefundTkt] TO [rt_read]
    AS [dbo];

