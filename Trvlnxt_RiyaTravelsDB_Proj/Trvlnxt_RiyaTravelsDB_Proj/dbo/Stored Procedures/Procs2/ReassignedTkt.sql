
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ReassignedTkt] --'products@riya.travel'
	@riyaPNR varchar(20),
	@gdsPNR varchar(20),
	@remark varchar(1500)
	as
BEGIN

   update BookMaster 
   set Iscancelled='RA',
   reassigned_remark=@remark
   where GDSPNR=@gdsPNR and RiyaPNR=@riyaPNR

	  end -- order by deptdate








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[ReassignedTkt] TO [rt_read]
    AS [dbo];

