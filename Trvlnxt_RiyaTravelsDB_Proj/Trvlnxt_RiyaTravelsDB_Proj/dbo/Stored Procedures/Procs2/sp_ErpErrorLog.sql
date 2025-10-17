-- =============================================
-- Author:		<Jishaan.S>
-- Create date: <05-05-2023>
-- Description:	<>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ErpErrorLog]
AS
BEGIN
select isnull(BM.riyaPNR,BM.GDSPNR) as 'RiyaPnr/BookingReferance',a.FK_tblbookmasterID,a.Type,a.Response,a.Request,a.CreatedOn from NewERPData_Log a 
LEFT JOIN tblPassengerBookDetails PB on a.FK_tblbookmasterID = PB.pid
RIGHT JOIN tblBookMaster BM on PB.fkBookMaster = BM.pkId
--LEFT JOIN Hotel_BookMaster HB on HB.pkId = a.FK_tblbookmasterID
where a.CreatedOn > GETDATE() - 2 and DATEDIFF(MINUTE,a.CreatedOn,GETDATE()) <= 180
and a.Type in ('Errror-CreateWOIns','False-CreateWOIns','Error-CreateWOIns')
and a.Response not like '%that cannot be found in the related table%'
and a.Response not like '%does not exist in NAV.%'
order by CreatedOn
END
