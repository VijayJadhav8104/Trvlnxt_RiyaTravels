





CREATE VIEW [dbo].[VWFetchInvoiceData]
AS
with cte as(
select 
				   B.pkId as 'Id',
				   B.orderId as 'InvoiceNo',
				   P.paxFName+space(1)+P.paxLName as 'paxname',
				   U.Address AS 'Address',
				   U.UserID,
				   B.riyaPNR as 'BookingId',
				   B.mobileNo as 'contact',
				   B.emailId as 'EmailId',
				   'YRTax:' + convert(varchar(10),isnull(B.YRTax,0))+  ' INTax:' + convert(varchar(10),isnull(B.INTax,0)) +  ' JNTax:' + convert(varchar(10),isnull(B.JNTax,0))
					+  ' OCTax :' + convert(varchar(10),isnull (B.OCTax,0)) +  ' ExtraTax:' + convert(varchar(10),isnull(B.ExtraTax,0)) 
					+   ' YQTax :' + convert(varchar(10),isnull(B.YQTax,0)) AS taxDesc,
				   B.RegistrationNumber as 'GSTRegNo',
				   B.GDSPNR,--PNR No.
				   lTRIM(REPLACE(replace(SUBSTRING(P.ticketNum, 1, CHARINDEX('/', P.ticketNum)), 'PAX', ''),'/','')) as ticketNum,--P.ticketNum, --ticket no.
				   t.frmSector+'/'+t.toSector as 'Sector',  --Sector Name		
				   CONVERT(DATE,B.deptTime) as 'TravelDT', --Date of Travel
				   t.airCode+'-'+t.flightNo as 'FlightNo', --Flight No	
				   LEFT(t.cabin,1) as 'cabin',	-- class
				   p.basicFare as 'Base',
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
					(p.basicFare + B.totalTax) as 'TotalFare',
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
								isnull(p.basicFare,00.00) --basic fare
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
					isnull(B.TotalDiscount,00.00) as 'Discount',
					(Select CONVERT(VARCHAR(11), SYSDATETIME(), 106) AS [DD MON YYYY])as 'invoiceDate'
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
					on B.LoginEmailID=U.UserID

					--and
					--B.pkId=35

)


select distinct *,dbo.fnNumberToWords ( [Total Receivable]) as 'no.InWords' from cte





