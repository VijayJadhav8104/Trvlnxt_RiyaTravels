
CREATE Procedure [dbo].[FetchInvoice] --'RT20190124114212838'

@OrderID  VARCHAR(50)

as 
BEGIN



declare @InvoiceNo as varchar(50);
declare @RegistrationNumber as varchar(50);
declare @Type as varchar(1);
declare @INo as varchar(10)
declare @GSTNo as varchar(50)

select @RegistrationNumber= RegistrationNumber from tblBookMaster where orderId=@OrderID

if (@RegistrationNumber is null)
	begin
	
	select top 1 @INo=PInvoice from tblInvoice where tinvoice is null order by pkid desc

	insert into tblInvoice (OrderID,PInvoice) values(@OrderID,ISNULL(@INo,0)+1)

	select top 1 @INo=PInvoice from tblInvoice  where tinvoice is null order by pkid desc

	set @Type='P'
	end
else
	begin
	select top 1 @INo=TInvoice from tblInvoice where pinvoice is null order by pkid desc
	insert into tblInvoice (OrderID,TInvoice) values(@OrderID,ISNULL(@INo,0)+1)
	select top 1 @INo=TInvoice from tblInvoice where pinvoice is null order by pkid desc
	set @Type='T'
	end;

	
	

	set @InvoiceNo='B2C' +  SUBSTRING(CONVERT(nvarchar(6),getdate(), 112),5,2) +  cast(year(getdate()) as varchar(4)) + @Type + 
	case when len(@INo)=1  then concat('00000',  @INo) 
	when len(@INo)=2  then concat('0000',  @INo)
	when len(@INo)=3  then concat('000',  @INo)
	when len(@INo)=4  then concat('00',  @INo)
	when len(@INo)=5  then concat('0',  @INo)
	when len(@INo)=6  then @INo
	end ;



	if (@RegistrationNumber is null)
	begin
	
	update tblInvoice set PaymentInvoiceNo=@InvoiceNo where OrderID=@OrderID
	end
else
	begin
	update tblInvoice set TaxInvoiceNo=@InvoiceNo where OrderID=@OrderID
	end;


with cte as(
select 
				   B.pkId as 'Id',
				   B.orderId as 'orderId',
				   P.paxFName+space(1)+P.paxLName as 'paxname',
				   U.Address AS 'Address',u.City,u.Pincode,u.Province,
				   U.UserID,
				   B.riyaPNR as 'BookingId',
				   B.mobileNo as 'contact',
				   B.emailId as 'EmailId',
				   'YRTax:' + convert(varchar(10),isnull(B.YRTax,0))+  ' INTax:' + convert(varchar(10),isnull(B.INTax,0)) +  ' JNTax:' + convert(varchar(10),isnull(B.JNTax,0))
					+  ' OCTax :' + convert(varchar(10),isnull (B.OCTax,0)) +  ' ExtraTax:' + convert(varchar(10),isnull(B.ExtraTax,0)) 
					+   ' YQTax :' + convert(varchar(10),isnull(B.YQTax,0)) AS taxDesc,
				   B.RegistrationNumber as 'GSTRegNo',
				   B.CompanyName,B.CAddress,
				   B.GDSPNR,--PNR No.
				   lTRIM(REPLACE(replace(SUBSTRING(P.ticketNum, 1, CHARINDEX('/', P.ticketNum)), 'PAX', ''),'/','')) as ticketNum,--P.ticketNum, --ticket no.
				   t.frmSector+'/'+t.toSector as 'Sector',  --Sector Name		
				   CONVERT(DATE,B.deptTime) as 'TravelDT', --Date of Travel
				   t.airCode+'-'+t.flightNo as 'FlightNo', --Flight No	
				   LEFT(t.cabin,1) as 'cabin',	-- class
				   B.basicFare as 'Base',
				   (Case 
					when 
						B.CounterCloseTime ='1'
						THEN 
							'Air-Dom'
						ELSE
							'Air-INT'
						End
					) as 'FlightType',

					B.totalTax as 'TotalTax', -- Airline Tax,
					(b.basicFare + B.totalTax) as 'TotalFare',
					--B.totalFare as 'TotalFare',					 
					--(p.basicFare + B.totalTax+B.AgentMarkup)as test,

					 (
						cast (round((B.TotalMarkup)*100/118,2) as  decimal(18,2)) 
					 ) as 'Convienience Fees',

					(
						cast (round(((
							(isnull(B.TotalMarkup,00.00))
								-
							(
								(isnull(B.TotalMarkup,00.00))*100/118
							)
						)/2),2) as  decimal(18,2)) 

					)as CGST,

					(
						cast (round(((
							(isnull(B.TotalMarkup,00.00))
								-
							(
								(isnull(B.TotalMarkup,00.00))*100/118
							)
						)/2),2) as  decimal(18,2)) 

					)as SGST,
					
					cast (round(((
							(	
								isnull(b.basicFare,00.00) --basic fare
									+		-- +
								isnull(B.totalTax,00.00)  --Airline Tax
									+		-- +
								(isnull(B.TotalMarkup,00.00))*100/118) --Convienience
									+					 -- +
								(
									((isnull(B.TotalMarkup,00.00))-
									((isnull(B.TotalMarkup,00.00))*100/118))/2
								)						 -- CGST
									+					 -- +
								(
									((isnull(B.TotalMarkup,00.00))-
									((isnull(B.TotalMarkup,00.00))*100/118))/2 
								)	
							)-	isnull(B.TotalDiscount,00.00)	),2 ) as  decimal(18,2)) 	 		 
						
					as 'Total Receivable',
					isnull(CAST(B.TotalDiscount AS  decimal(18,2)) ,00.00) as 'Discount' ,
					(Select CONVERT(VARCHAR(11), SYSDATETIME(), 106) AS [DD MON YYYY])as 'invoiceDate',
					(SELECT top 1 GST_Type FROM tblStateGST WHERE GST_Reg_No=SUBSTRING(B.RegistrationNumber, 1, 2)) AS GstType,
					(SELECT top 1 Description + ' (' + GST_Reg_No +')' FROM tblStateGST WHERE GST_Reg_No=SUBSTRING(B.RegistrationNumber, 1, 2)) AS GST_Reg_No,
					P.totalFare AS paxtotal,P.basicFare as paxbasic,P.totalTax as paxtax
				   from
					tblBookMaster B
					inner join 
					tblBookItenary t
					on
					B.pkId=t.fkBookMaster

					inner join
					tblPassengerBookDetails P
					on
					B.pkId=p.fkBookMaster
					LEFT join
					UserLogin U
					on B.LoginEmailID=U.UserID WHERE B.orderId=@OrderID

					--and
					--B.pkId=35

)
SELECT * FROM cte

SELECT (b1.basicFare + isnull(b2.basicFare,0)) as basicFare,(b1.totalTax + isnull(b2.totalTax,0)) as totalTax,
(((b1.totalFare+isnull(b2.totalFare,0)) +(b1.TotalMarkup + isnull(b2.TotalMarkup,0)))-(b1.TotalDiscount + isnull(b2.TotalDiscount,0))) AS 'Total Receivable',
'YRTax:' + convert(varchar(10),isnull((b1.YRTax+isnull(b2.YRTax,0)),0))+
' INTax:' + convert(varchar(10),isnull((b1.INTax + isnull(b2.INTax,0)),0)) 
+  ' JNTax:' + convert(varchar(10),isnull((b1.JNTax+isnull(b2.JNTax,0)),0))
+  ' OCTax :' + convert(varchar(10),isnull ((b1.OCTax + isnull(b2.OCTax,0)),0)) 
+  ' ExtraTax:' + convert(varchar(10),isnull((b1.ExtraTax + isnull(b2.ExtraTax,0)),0)) 
+   ' YQTax :' + convert(varchar(10),isnull((b1.YQTax + isnull(b2.YQTax,0)),0)) AS taxDesc,
dbo.fnNumberToWords ((((b1.totalFare+isnull(b2.totalFare,0)) +(b1.TotalMarkup + isnull(b2.TotalMarkup,0)))-(b1.TotalDiscount + isnull(b2.TotalDiscount,0)))) as 'no.InWords',@InvoiceNo as 'InvoiceNo'
 FROM tblBookMaster b1 
 left join tblBookMaster b2 on b2.orderId=b1.orderId and b2.returnFlag=1
 WHERE b1.orderId=@OrderID
 and b1.returnFlag=0


 
 
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchInvoice] TO [rt_read]
    AS [dbo];

