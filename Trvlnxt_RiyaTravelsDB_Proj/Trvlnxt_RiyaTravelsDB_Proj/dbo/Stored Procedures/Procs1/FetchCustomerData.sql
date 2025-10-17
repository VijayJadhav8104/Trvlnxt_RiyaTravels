
CREATE procedure [dbo].[FetchCustomerData] 
@frmDate datetime,
@toDate datetime,
@status tinyint,
@BookingDateRequired tinyint
as
BEGIN
if(@status=0)
	BEGIN
		if(@BookingDateRequired=0)
			begin
				SELECT distinct  emailId,mobileNo,'' as 'BookingDate',
				case  when a.IsBooked=1 then 'Confirmed' when b.Iscancelled=1 then 'Cancelled'  
				when b.IsRefunded=1 then 'Refunded' else 'Failed' end as Status FROM tblBookMaster a
				inner join tblPassengerBookDetails b on b.fkBookMaster=a.pkId
				where convert(date,a.inserteddate) >=convert(date,@frmDate)
				 and convert(date,a.inserteddate) <=convert(date,@toDate)
			end
		else
			begin
				SELECT distinct  emailId,mobileNo,a.inserteddate as 'BookingDate',  
				case  when a.IsBooked=1 then 'Confirmed' when b.Iscancelled=1 then 'Cancelled'  
				when b.IsRefunded=1 then 'Refunded' else 'Failed' end as Status FROM tblBookMaster a
				inner join tblPassengerBookDetails b on b.fkBookMaster=a.pkId
				where convert(date,a.inserteddate) >=convert(date,@frmDate)
				 and convert(date,a.inserteddate) <=convert(date,@toDate) 
			end
	END
	ELSE IF(@status=1)
	BEGIN
		if(@BookingDateRequired=0)
			begin
				SELECT distinct  emailId,mobileNo,'' as 'BookingDate','' as Status FROM tblBookMaster WHERE IsBooked=1
				and  convert(date,inserteddate) >=convert(date,@frmDate)
				 and convert(date,inserteddate) <=convert(date,@toDate)
			
			end
		else
			begin
				SELECT distinct  emailId,mobileNo,inserteddate as 'BookingDate','' as Status FROM tblBookMaster WHERE IsBooked=1
				and  convert(date,inserteddate) >=convert(date,@frmDate)
				 and convert(date,inserteddate) <=convert(date,@toDate)
			
			end
	END
	ELSE 
	BEGIN
		if(@BookingDateRequired=0)
			begin
				SELECT distinct IP , COUNT(IP) AS  TOTIP  FROM tblBookMaster WHERE IsBooked=1
				and  convert(date,inserteddate) >=convert(date,@frmDate)
				 and convert(date,inserteddate) <=convert(date,@toDate)
				 GROUP BY IP
			
			end
		else
			begin
				SELECT distinct IP , COUNT(IP) AS  TOTIP FROM tblBookMaster WHERE IsBooked=1
				and  convert(date,inserteddate) >=convert(date,@frmDate)
				 and convert(date,inserteddate) <=convert(date,@toDate)
			     GROUP BY IP
			
			end
	END

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchCustomerData] TO [rt_read]
    AS [dbo];

