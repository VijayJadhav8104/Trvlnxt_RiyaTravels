
CREATE PROCEDURE [dbo].[FetchRefundAndCancellation]  
 @RiyaPNR varchar(20),        
 @GDSPNR varchar(20)        
AS        
BEGIN        
        
if (@GDSPNR !='')        
        
BEGIN        
       
 ---Passenger details        
 IF NOT EXISTS (        
 SELECT DISTINCT paxFName,paxLName,mobileNo,emailId,p.MCOAmount, convert(varchar(110), dateOfBirth, 106) AS DOB,        
 case when  len(ticketNum)=8 then substring(ticketNum,1,6) else ticketNum end as ticketNum,        
 (CASE WHEN CHARINDEX('/',ticketNum)>0         
 THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum))))         
 ELSE ticketNum END ) as 'TicketNumber', title,         
 P.CancelledDate,p.RefundedDate,B.OfficeID,B.Country,ROE,ISNULL(AOI.Currency,'INR') AS Currency,p.paxType,airCode,B.FareType,B.GDSPNR,B.pkId,P.pid,IsBooked        
 ,B.BookingSource,P.baggage,
 b.totalFare,
 --(select SUM(cast(((bm.totalFare+isnull(bm.TotalMarkup,0)+isnull(bm.AgentMarkup,0) +isnull(bm.B2BMarkup,0))* bm.ROE * bm.AgentROE +isnull(bm.ServiceFee,0)+isnull(bm.GST,0)+ isnull(bm.BFC,0)) as decimal(18,2))) From tblBookMaster as bm where bm.GDSPNR = b.GDSPNR AND bm.riyaPNR = b.riyaPNR)  +    ISNULL((Select SUM(SSR_Amount)* b.ROE * b.AgentROE  from tblSSRDetails as ssr Where ssr.fkBookMaster IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR)),0) as 'totalFare' 
 p.passportNum,p.passexp    
 ,ISNULL(P.HupAmount,0) AS HupAmount
 ,B.VendorName
 from tblBookMaster B        
 join tblPassengerBookDetails P on B.pkId = P.fkBookMaster        
 LEFT JOIN tblAmadeusOfficeID AOI ON AOI.OfficeID=B.OfficeID and AOI.CountryCode=B.Country AND         
 ((B.AgentID='B2C' AND AOI.CountryCode=B.Country) OR (B.AgentID!='B2C'))        
 left join AirlinesName AN on an._CODE=b.airCode        
 WHERE  B.GDSPNR = @GDSPNR  AND B.RiyaPNR = @RiyaPNR and p.isReturn=0 and  b.totalFare>0)       
 BEGIN        
  SELECT DISTINCT paxFName,paxLName,mobileNo,emailId,p.MCOAmount, convert(varchar(110), dateOfBirth, 106) AS DOB,        
  case when  len(ticketNum)=8 then substring(ticketNum,1,6) else ticketNum end as ticketNum,        
  (CASE WHEN CHARINDEX('/',ticketNum)>0         
  THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum))))         
  ELSE ticketNum END ) as 'TicketNumber', title,         
  P.CancelledDate,p.RefundedDate,B.OfficeID,B.Country,ROE,ISNULL(AOI.Currency,'INR') AS Currency,p.paxType,airCode,B.FareType,B.GDSPNR,B.pkId,P.pid,IsBooked        
  ,B.BookingSource,P.baggage,p.passportNum,p.passexp,ISNULL(P.HupAmount,0)AS HupAmount  ,b.VendorName    
      
    ,(Select Sum(totalFare)* b.ROE * B.AgentROE+ISNULL(b.B2BMarkup,0)+isnull(p.ServiceFee,0)+isnull(p.GST,0)+isnull(p.BFC,0)  From tblPassengerBookDetails where [paxType] = p.paxType AND [paxFName] = p.paxFName AND [paxLName] = p.paxLName      
 and [fkBookMaster] IN (Select [PKID] from tblBookMaster where [GDSPNR] = @GDSPNR  AND [RiyaPNR] = @RiyaPNR)) as totalFare     
      
  from tblBookMaster B        
  join tblPassengerBookDetails P on B.pkId = P.fkBookMaster        
  LEFT JOIN tblAmadeusOfficeID AOI ON AOI.OfficeID=B.OfficeID and AOI.CountryCode=B.Country and        
  ((B.AgentID='B2C' AND AOI.CountryCode=B.Country) OR (B.AgentID!='B2C'))        
  left join AirlinesName AN on an._CODE=b.airCode        
  WHERE  B.GDSPNR = @GDSPNR  AND B.RiyaPNR = @RiyaPNR and p.isReturn=1 and  b.totalFare>0 order by p.pid        
 END        
 ELSE        
 BEGIN        
  SELECT DISTINCT paxFName,paxLName,mobileNo,emailId,p.MCOAmount, convert(varchar(110), dateOfBirth, 106) AS DOB,        
  case when  len(ticketNum)=8 then substring(ticketNum,1,6) else ticketNum end as ticketNum,        
  (CASE WHEN CHARINDEX('/',ticketNum)>0         
  THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum))))         
  ELSE ticketNum END ) as 'TicketNumber', title,         
  P.CancelledDate,p.RefundedDate,B.OfficeID,B.Country,ROE,ISNULL(AOI.Currency,'INR') AS Currency,p.paxType,airCode,B.FareType,B.GDSPNR,B.pkId,P.pid,IsBooked        
  ,B.BookingSource,P.baggage,p.passportNum,p.passexp,ISNULL(P.HupAmount,0) AS HupAmount  ,b.VendorName   
      
  ,(Select Sum(totalFare)* b.ROE * B.AgentROE+ISNULL(b.B2BMarkup,0)+isnull(p.ServiceFee,0)+isnull(p.GST,0)+isnull(p.BFC,0)    From tblPassengerBookDetails where [paxType] = p.paxType AND [paxFName] = p.paxFName AND [paxLName] = p.paxLName      
 and [fkBookMaster] IN (Select [PKID] from tblBookMaster where [GDSPNR] = @GDSPNR  AND [RiyaPNR] = @RiyaPNR)) as totalFare       
      
  from tblBookMaster B        
  join tblPassengerBookDetails P on B.pkId = P.fkBookMaster        
  LEFT JOIN tblAmadeusOfficeID AOI ON AOI.OfficeID=B.OfficeID and AOI.CountryCode=B.Country and        
  ((B.AgentID='B2C' AND AOI.CountryCode=B.Country) OR (B.AgentID!='B2C'))        
  left join AirlinesName AN on an._CODE=b.airCode        
  WHERE  B.GDSPNR = @GDSPNR  AND B.RiyaPNR = @RiyaPNR and p.isReturn=0 and  b.totalFare>0 order by p.pid        
 END        
 ---Passenger details        
        
 --Travel details         
 SELECT  tBI.pkId,tBI.airName+'-'+ tBI.flightNo as airname, tBI.frmSector as frmsector ,tBI.toSector as tosector,tBI.deptTime,tBI.arrivalTime,tB.RiyaPNR ,tBI.cabin,tB.TotalDiscount,        
 isnull(tB.inserteddate_old,tB.inserteddate) as 'inserteddate',(isnull(tb.FlatDiscount,0) + isnull(tb.PromoDiscount,0)) as FlatDiscount,tB.FareType        
 From tblBookMaster tB         
 inner join tblBookItenary tBI on tBI.fkBookMaster = tB.pkId        
 WHERE tB.GDSPNR= @GDSPNR AND tB.RiyaPNR = @RiyaPNR        
 order by tB.pkId        
 --Travel details         
        
        
 --farebasis,airlinePNR,cabin         
 SELECT DISTINCT tB.pkId, farebasis,airlinePNR,cabin,tB.ROE,tB.FareType as roe from tblBookItenary tBI         
 inner join tblBookMaster tB  on tB.pkId = tBI.fkBookMaster        
 WHERE tB.GDSPNR= @GDSPNR AND tB.RiyaPNR =@RiyaPNR        
 order by tB.pkId        
 --farebasis,airlinePNR,cabin         
         
        
 --Fare Details        
 select        
 -- DISTINCT(B.frmsector +'-'+ B.tosector)  as sector,        
 DISTINCT(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')         
 AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId) as 'Sector',        
 --commented by asmi((totalFare *AgentROE*ROE) + ISNULL(B2BMarkup,0) + isnull(b.AgentMarkup,0)) as totalFare,
(select SUM (cast((((bm.totalFare+isnull(bm.TotalMarkup,0)+isnull(bm.AgentMarkup,0))-isnull(bm.TotalDiscount,0))* bm.ROE * bm.AgentROE + isnull(bm.B2BMarkup,0)
+ isnull(bm.ServiceFee,0)+isnull(bm.GST,0) + isnull(bm.BFC,0)) as decimal(18,2))) from tblBookMaster as bm 
where bm.GDSPNR = b.GDSPNR AND bm.riyaPNR = b.riyaPNR) + ISNULL((Select SUM(SSR_Amount)* b.ROE * b.AgentROE  from tblSSRDetails as ssr Where ssr.fkBookMaster 
IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR)),0)+ISNULL(b.TotalHupAmount,0)   as totalFare,
 totalTax,         
 ((basicFare*AgentROE*ROE) + isnull(b.AgentMarkup,0) + ISNULL(b.TotalLonServiceFee,0)) as basicFare,        
 (isnull (TotalDiscount,0) + isnull(FlatDiscount,0) + isnull(PromoDiscount,0)) as TotalDiscount,         
        
 'ServiceCharge: ' + convert(varchar(10),ISNULL(ServiceCharge,0)) + ' YRTax:' + convert(varchar(10),isnull(YRTax,0))        
 +  ' INTax:' + convert(varchar(10),isnull(INTax,0)) +  ' JNTax:' + convert(varchar(10),isnull(JNTax,0))  
  + ' K7Tax:' + convert(varchar(10),isnull(K7Tax,0)) 
  +  ' OCTax :' + convert(varchar(10),isnull (OCTax,0)) +  ' ExtraTax:' + convert(varchar(10),isnull(ExtraTax,0))         
 +   ' YQTax :' + convert(varchar(10),isnull(YQTax,0))  as taxdesc,b.pkId,cast(isnull((B.AgentMarkup/b.ROE),0) as decimal(10,2)) as AgentMarkup,B.FareType        
 ,ISNULL(AOI.Currency,'INR') AS Currency,ISNULL(B.ROE,1) as ROE ,ISNULL(B.AgentROE,1) as AgentROE, ISNULL(b.B2BMarkup,0) AS B2BMarkup
 , (select top 1 farebasis from tblBookItenary I where  I.fkBookMaster=B.pkId ) as farebasis
   from tblBookMaster B        
   LEFT JOIN tblAmadeusOfficeID AOI ON AOI.OfficeID=B.OfficeID and AOI.CountryCode =  B.Country     
   inner join tblBookItenary I ON I.fkBookMaster=B.pkId        
   where  totalFare >0  and GDSPNR= @GDSPNR and B.RiyaPNR = @RiyaPNR        
   order by b.pkId        
  --Fare Details        
        
  ---Refund amount calculation        
 SELECT  CASE WHEN agentid ='B2C' THEN isnull(TotalMarkup,0)        
  ELSE isnull( AgentMarkup,0)  END as serviceCharge,totalFare,CancellationCharge,        
TotalDiscount,(isnull(FlatDiscount,0) + isnull(PromoDiscount,0)) as FlatDiscount,FareType        
 FROM tblBookMaster          
 WHERE GDSPNR= @GDSPNR  AND RiyaPNR = @RiyaPNR        
 ---Refund amount calculation        
        
END        
        
ELSE        
BEGIN        
        
 ---Passenger details        
 SELECT DISTINCT paxFName,paxLName,mobileNo,emailId,p.MCOAmount, convert(varchar(110), dateOfBirth, 106) AS DOB,        
 case when  len(ticketNum)=8 then substring(ticketNum,1,6) else ticketNum end as ticketNum,        
 (CASE WHEN CHARINDEX('/',ticketNum)>0         
THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum))))         
ELSE ticketNum END )as 'TicketNumber',title,        
 P.CancelledDate,p.RefundedDate,B.OfficeID,B.Country,B.ROE,ISNULL(AOI.Currency,'INR') AS Currency,p.paxType,airCode,B.FareType ,B.GDSPNR,B.pkId ,P.pid,IsBooked         
 ,B.BookingSource,p.passportNum,p.passexp,ISNULL(P.HupAmount,0) AS HupAmount   ,b.VendorName     
       
 ,(Select Sum(totalFare) From tblPassengerBookDetails where paxType = p.paxType AND paxFName = p.paxFName AND paxLName = p.paxLName      
 and [fkBookMaster] IN (Select [PKID] from tblBookMaster where RiyaPNR = @RiyaPNR)) as totalFare      
       
 from tblBookMaster B        
 join tblPassengerBookDetails P on B.pkId = P.fkBookMaster        
 LEFT JOIN tblAmadeusOfficeID AOI ON AOI.OfficeID=B.OfficeID and AOI.CountryCode=B.Country AND         
 ((B.AgentID='B2C' AND AOI.CountryCode=B.Country) OR (B.AgentID!='B2C'))        
 left join AirlinesName AN on an._CODE=b.airCode        
 WHERE B.RiyaPNR = @RiyaPNR and p.isReturn=0 order by p.pid        
 ---Passenger details        
        
 --Travel details         
 SELECT  tBI.pkId,tBI.airName+'-'+ tBI.flightNo as airname, tBI.frmSector as frmsector ,tBI.toSector as tosector,tBI.deptTime,tBI.arrivalTime,tB.RiyaPNR ,tBI.cabin        
 ,tB.TotalDiscount, tB.inserteddate,(isnull(tb.FlatDiscount,0) + isnull(tb.PromoDiscount,0)) as FlatDiscount,tB.FareType        
 From tblBookMaster tB         
 inner join tblBookItenary tBI on tBI.fkBookMaster = tB.pkId        
 WHERE tB.RiyaPNR = @RiyaPNR        
 order by tB.pkId        
 --Travel details         
        
 --farebasis,airlinePNR,cabin         
 SELECT DISTINCT tB.pkId, farebasis,airlinePNR,cabin,tB.ROE,tB.FareType from tblBookItenary tBI         
 inner join tblBookMaster tB  on tB.pkId = tBI.fkBookMaster        
 WHERE tB.RiyaPNR =@RiyaPNR        
 order by tB.pkId        
 --farebasis,airlinePNR,cabin         
        
 --Fare Details        
  select DISTINCT(B.frmsector +'-'+ B.tosector)  as sector,        
   --commented by asmi((totalFare*AgentROE*ROE) + ISNULL(B2BMarkup,0)  + isnull(b.AgentMarkup,0)) as totalFare,
       (select SUM (cast((((bm.totalFare+isnull(bm.TotalMarkup,0)+isnull(bm.AgentMarkup,0))-isnull(bm.TotalDiscount,0))* bm.ROE * bm.AgentROE + isnull(bm.B2BMarkup,0) + isnull(bm.ServiceFee,0)+isnull(bm.GST,0) + isnull(bm.BFC,0) ) as decimal(18,2))) from 

tblBookMaster as bm where bm.GDSPNR = b.GDSPNR AND bm.riyaPNR = b.riyaPNR) +   ISNULL( (Select SUM(SSR_Amount)* b.ROE * b.AgentROE  from tblSSRDetails as ssr Where ssr.fkBookMaster IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR)),0)   as totalFare,

   totalTax,        
   ((basicFare*AgentROE*ROE) + isnull(b.AgentMarkup,0) + ISNULL(b.TotalLonServiceFee,0)) as basicFare,(isnull(TotalDiscount,0) + isnull(FlatDiscount,0) + isnull(PromoDiscount,0)) as TotalDiscount,         
 'ServiceCharge: ' + convert(varchar(10),ISNULL(ServiceCharge,0)) + ' YRTax:' + convert(varchar(10),isnull(YRTax,0))        
 +  ' INTax:' + convert(varchar(10),isnull(INTax,0)) +  ' JNTax:' + convert(varchar(10),isnull(JNTax,0))   
   + ' K7Tax:' + convert(varchar(10),isnull(K7Tax,0)) 
  +  ' OCTax :' + convert(varchar(10),isnull (OCTax,0)) +  ' ExtraTax:' + convert(varchar(10),isnull(ExtraTax,0))         
 +   ' YQTax :' + convert(varchar(10),isnull(YQTax,0))  as taxdesc,b.pkId,cast(isnull((B.AgentMarkup/b.ROE),0) as decimal(10,2)) as AgentMarkup        
 ,B.FareType        
  ,ISNULL(AOI.Currency,'INR') AS Currency,B.ROE ,B.AgentROE,ISNULL(b.B2BMarkup,0) AS B2BMarkup 
  , (select top 1 farebasis from tblBookItenary I where  I.fkBookMaster=B.pkId ) as farebasis
   from tblBookMaster B        
   LEFT JOIN tblAmadeusOfficeID AOI ON AOI.OfficeID=B.OfficeID and AOI.CountryCode =  B.Country      
   inner join tblBookItenary I ON I.fkBookMaster=B.pkId where  B.RiyaPNR = @RiyaPNR          
    order by b.pkId        
 --Fare Details        
        
 ---Refund amount calculation        
 SELECT  CASE WHEN agentid ='B2C' THEN isnull(TotalMarkup,0)        
  ELSE isnull( AgentMarkup,0)  END as serviceCharge,totalFare,CancellationCharge,        
TotalDiscount,(isnull(FlatDiscount,0) + isnull(PromoDiscount,0)) as FlatDiscount,FareType        
 FROM tblBookMaster          
 WHERE RiyaPNR = @RiyaPNR        
 ---Refund amount calculation  
 
         
END        
        
 ---payment history        
--select order_id,tracking_id,order_status,payment_mode,card_name        
--mer_amount, CardNumber,ExpiryDate, CVV, CardType from Paymentmaster         
--where order_id in (select orderid from tblBookMaster where riyaPNR=@riyaPNR)        
        
--select distinct(order_id),tracking_id,order_status,payment_mode,card_name, isnull(mer_amount,0)*ROE*AgentROE mer_amount,b.AgentROE,    
select distinct(order_id),tracking_id,order_status,payment_mode,card_name, isnull(mer_amount,0) mer_amount,b.AgentROE,        

--CONVERT (DECIMAL(18,10),mer_amount)/ b.ROE as mer_amount,         
CardNumber,ExpiryDate, CVV, CardType,currency,b.FareType from Paymentmaster p        
inner join tblBookMaster   b on b.orderid=p.order_id        
where b.riyaPNR=@riyaPNR        
        
 ---payment history        
        
---cancellation history        
select AM.FullName, ch.UpdateDate,ch.paxfname,ch.paxtype,ch.totalfare,ch.CancellationCharge,ch.ServiceCharge,ch.Discount,        
ch.RefundAmount,ch.totalfare,ch.sector,ch.Panelty,ch.totalfare,ch.TotalRefund, ch.HistoryID,ch.returnflag  from CancellationHistory CH        
Inner join adminMaster AM ON AM.Id=CH.UpdatedBy        
 where ch.RiyaPNR=@RiyaPNR and ch.FlagType=1  AND ch.GDSPNR=@GDSPNR ORDER BY CH.UpdateDate desc        
        
        
 ---cancellation history        
        
 ---refund history        
select AM.FullName, ch.UpdateDate,ch.paxfname,ch.paxtype,ch.totalfare,ch.CancellationCharge,ch.ServiceCharge,ch.Discount,        
ch.RefundAmount,ch.totalfare,ch.sector,ch.Panelty,p.tracking_id,ch.TotalRefund,ch.HistoryID,ch.returnflag,t.FareType from CancellationHistory CH        
Inner join adminMaster AM ON AM.Id=CH.UpdatedBy        
inner join tblBookMaster t on t.orderId=ch.OrderId        
inner join paymentmaster P on P.order_ID=t.orderid        
 where ch.RiyaPNR=@RiyaPNR and ch.FlagType=2  AND ch.GDSPNR=@GDSPNR ORDER BY CH.UpdateDate desc        
   ---refund history        
         
 ---single cancellation history 
 select p.pid, paxFName, paxType, p.totalFare,p.CancellationCharge,b.serviceCharge,ISNULL((b.TotalDiscount + b.FlatDiscount +b.PromoDiscount),0) as 'Discount',B.pkId,B.CounterCloseTime ,B.FareType        
 from tblPassengerBookDetails P        
 inner join tblBookMaster B ON B.pkId=p.fkBookMaster        
  where RiyaPNR = @RiyaPNR and b.GDSPNR=@GDSPNR and p.isReturn=0        
  order by paxType        
---single cancellation history        
        
         
 ---return cancellation history        
   select p.pid,paxFName, paxType, p.totalFare,p.CancellationCharge,b.serviceCharge,ISNULL((b.TotalDiscount + b.FlatDiscount +b.PromoDiscount),0) as 'Discount',B.pkId,B.CounterCloseTime ,B.FareType        
 from tblPassengerBookDetails P        
 inner join tblBookMaster B ON B.pkId=p.fkBookMaster        
  where RiyaPNR = @RiyaPNR and b.GDSPNR=@GDSPNR and p.isReturn=1        
 order by paxType        
  ---return cancellation history        
        
  SELECT Remark,        
  --UserID         
  --CASE B2BAgent WHEN 1 THEN (SELECT FirstName +' '+ LastName FROM AgentLogin WHERE AgentLogin.UserID=AgentHistory.UserId)         
  --    ELSE (SELECT FullName FROM adminMaster WHERE adminMaster.Id=AgentHistory.UserId)         
   ISNULL((SELECT FullName FROM adminMaster WHERE adminMaster.Id=AgentHistory.UserId),          
   (SELECT FirstName +' '+ LastName FROM AgentLogin WHERE AgentLogin.UserID=AgentHistory.UserId))        
   as UserID , InsertDate        
  FROM  AgentHistory WHERE OrderId = (SELECT TOP 1 orderId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)        
        
        
select UserName,FirstName,ISNULL(R.AgencyName,R1.AgencyName) AS AgencyName,B.FareType from AgentLogin UL        
  inner join tblBookMaster B ON B.AgentID=CONVERT(varchar(10), UL.UserID)        
  LEFT join B2BRegistration R ON R.FKUserID=UL.UserID        
  LEFT join B2BRegistration R1 ON R1.FKUserID=UL.ParentAgentID        
  WHERE  RiyaPNR = @RiyaPNR    
  

  ---SSR Amount Passenger wise = Added by Nitish 10-03-2022

Select p.paxFName, p.paxLName,(Select Cast( ISNULL(SUM(SSR_Amount),0)* b.ROE * b.AgentROE  as decimal(10,2))  from tblSSRDetails as ssr
Where ssr.fkBookMaster IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR) and ssr.fkPassengerid=p.pid) as SSRAmount
from tblBookMaster B        
left join tblPassengerBookDetails P on B.pkId = P.fkBookMaster
 Where  GDSPNR= @GDSPNR  AND RiyaPNR = @RiyaPNR 
---SSR Amount Passenger wise
        
	
 -- START SSR Details Display
	 SELECT 
			tblPassengerBookDetails.paxFName + ' ' 
					   + ISNULL(tblPassengerBookDetails.paxLName, '') AS PaxName
			,tblBookItenary.frmSector +'->'+tblBookItenary.toSector AS Sector
			, ISNULL(SSR_Type,'') AS SSRType
			, ISNULL(SSR_Name,'') AS SSRName
			, ISNULL(SSR_Code,'') AS SSRCode
			--,ISNULL(SSR_Amount, 0) AS SSRAmount
			,(CASE 
			WHEN ISNULL(tblSSRDetails.ROE,0) = 0 
			THEN 
				  CAST(ISNULL(tblSSRDetails.SSR_Amount,0) * tblBookMaster.ROE AS decimal(10,2))
			ELSE 
				CAST(ISNULL(tblSSRDetails.SSR_Amount, 0) * ISNULL(tblSSRDetails.ROE,0)  AS decimal(10,2))
		   END) AS SSRAmount
		FROM tblSSRDetails
		INNER JOIN tblBookMaster ON tblSSRDetails.fkBookMaster = tblBookMaster.pkId
		INNER JOIN tblPassengerBookDetails ON tblSSRDetails.fkPassengerid = tblPassengerBookDetails.pid
		INNER JOIN tblBookItenary ON tblSSRDetails.fkItenary = tblBookItenary.pkid
		INNER JOIN mCountryCurrency  ON mCountryCurrency.CountryCode= tblBookMaster.Country       
		WHERE tblBookMaster.riyaPNR =@RiyaPNR
		AND SSR_Code IS NOT NULL AND SSR_Status =1 
          
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchRefundAndCancellation] TO [rt_read]
    AS [dbo];

