CREATE PROCEDURE [dbo].[FetchRefundAndCancellationNew]  --[FetchRefundAndCancellationNew] 'N706UJ','MZ74T7'            
 @RiyaPNR varchar(20),            
 @GDSPNR varchar(20)            
AS            
BEGIN            
     declare @adtcount int=0,@chdcount int=0       
  select @adtcount=count(*) from  tblPassengerBookDetails     
  where fkBookMaster in(select pkId from tblBookMaster where riyaPNR =@RiyaPNR and returnFlag = 0)    
  and (paxType  ='ADULT' or paxType='ADT' OR paxType='A')    
 select @chdcount=count(*) from  tblPassengerBookDetails     
  where fkBookMaster in(select pkId from tblBookMaster where riyaPNR =@RiyaPNR and returnFlag = 0)    
  and (paxType  ='CHILD' or paxType='CHD'  or paxType='C')    
if (@GDSPNR !='')            
            
BEGIN            
            
 ---Passenger details            
 SELECT DISTINCT paxFName,paxLName,mobileNo,emailId, convert(varchar(110), dateOfBirth, 106) AS DOB,          
 case when  len(ticketNum)=8 then substring(ticketNum,1,6) else ticketNum end as ticketNum,title,B.flightNo,p.passportNum,     
 P.CancelledDate,p.RefundedDate,B.OfficeID,B.Country,ROE,ISNULL(AOI.Currency,'INR') AS Currency,p.paxType,B.airCode,B.FareType,B.GDSPNR,B.pkId,P.pid,IsBooked          
 ,B.BookingSource,P.baggage,b.totalFare,p.passportNum,p.passexp,p.MCOAmount    
 ,@adtcount as noOfAdult,@chdcount as noOfChild,p.nationality ,B.orderId,B.returnFlag,P.PanNumber
 from tblBookMaster B          
 join tblPassengerBookDetails P on B.pkId = P.fkBookMaster          
 LEFT JOIN tblAmadeusOfficeID AOI ON AOI.OfficeID=B.OfficeID and AOI.CountryCode=B.Country  
 WHERE  B.GDSPNR = @GDSPNR  AND B.RiyaPNR = @RiyaPNR order by paxType          
 ---Passenger details          
          
 --Travel details           
 SELECT distinct tB.pkId,tB.airName+'-'+ tbi.flightNo as airname, tb.airCode,tb.flightNo, tBI.frmSector as frmsector ,tBI.toSector as tosector,tBI.deptTime,tBI.arrivalTime,tB.RiyaPNR ,isnull(tBI.cabin,'NA') cabin,tB.TotalDiscount,          
 tB.inserteddate,(isnull(tb.FlatDiscount,0) + isnull(tb.PromoDiscount,0)) as FlatDiscount,tB.FareType ,tb.returnFlag         
 From tblBookMaster tB           
 left join tblBookItenary tBI on tBI.fkBookMaster = tB.pkId          
 WHERE tB.GDSPNR= @GDSPNR AND tB.RiyaPNR = @RiyaPNR          
 order by tBi.deptTime                 
 --Travel details             
            
            
 --farebasis,airlinePNR,cabin             
 SELECT DISTINCT tB.pkId, farebasis,airlinePNR,cabin,tB.ROE,tB.FareType as roe from tblBookItenary tBI             
 inner join tblBookMaster tB  on tB.pkId = tBI.fkBookMaster            
 WHERE tB.GDSPNR= @GDSPNR AND tB.RiyaPNR =@RiyaPNR            
 order by tB.pkId            
 --farebasis,airlinePNR,cabin             
             
            
 --Fare Details            
 select DISTINCT(B.frmsector +'-'+ B.tosector)  as sector,(totalFare + isnull(b.MCOAmount,0) + isnull(b.AgentMarkup,0) + isnull(b.ServiceFee,0) + isnull(b.TotalVendorServiceFee,0) + isnull(b.GST,0) + isnull(b.bfc,0)) as totalFare,totalTax,             
 (basicFare + isnull(b.AgentMarkup,0)) as basicFare,(isnull (TotalDiscount,0) + isnull(FlatDiscount,0) + isnull(PromoDiscount,0)) as TotalDiscount,             
 'ServiceCharge: ' + convert(varchar(10),ServiceCharge) + ' YRTax:' + convert(varchar(10),isnull(YRTax,0))            
 +  ' INTax:' + convert(varchar(10),isnull(INTax,0)) +  ' JNTax:' + convert(varchar(10),isnull(JNTax,0))            
  +  ' OCTax :' + convert(varchar(10),isnull (OCTax,0)) +  ' ExtraTax:' + convert(varchar(10),isnull(ExtraTax,0))             
 +   ' YQTax :' + convert(varchar(10),isnull(YQTax,0))  as taxdesc,I.farebasis,b.pkId,cast(isnull((B.AgentMarkup/b.ROE),0) as decimal(10,2)) as AgentMarkup,B.FareType            
 ,ISNULL(AOI.Currency,'INR') AS Currency  ,isnull(B.ROE,1) ROE ,isnull(B.AgentROE,1 ) AgentROE, ISNULL(b.B2BMarkup,0) B2BMarkup,B.MCOAmount  ,B.ServiceFee,B.GST,(CASE WHEN B.basicFare > 0 THEN B.bfc ELSE 0 END)  as bfc        
   from tblBookMaster B            
   LEFT JOIN tblAmadeusOfficeID AOI ON AOI.OfficeID=B.OfficeID  and AOI.CountryCode=B.Country          
   left join tblBookItenary I ON I.fkBookMaster=B.pkId            
   where GDSPNR= @GDSPNR and B.RiyaPNR = @RiyaPNR            
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
 SELECT DISTINCT paxFName,paxLName,mobileNo,emailId, convert(varchar(110), dateOfBirth, 106) AS DOB,          
 case when  len(ticketNum)=8 then substring(ticketNum,1,6) else ticketNum end as ticketNum,title, B.flightNo ,p.passportNum,        
 P.CancelledDate,p.RefundedDate,B.OfficeID,B.Country,B.ROE,ISNULL(AOI.Currency,'INR') AS Currency,p.paxType,airCode,B.FareType ,B.GDSPNR,B.pkId ,B.returnFlag,P.pid,IsBooked           
 ,B.BookingSource,P.baggage,b.totalFare,p.passportNum,p.passexp   ,p.PanNumber
 ,@adtcount as noOfAdult,@chdcount as noOfChild,p.nationality  
 from tblBookMaster B          
 join tblPassengerBookDetails P on B.pkId = P.fkBookMaster          
 LEFT JOIN tblAmadeusOfficeID AOI ON AOI.OfficeID=B.OfficeID and AOI.CountryCode=B.Country          
 WHERE B.RiyaPNR = @RiyaPNR order by paxType          
 ---Passenger details          
          
 --Travel details           
 SELECT  tBI.pkId,tBI.airName+'-'+ tBI.flightNo as airname, tb.airCode,tb.flightNo,tBI.frmSector as frmsector ,tBI.toSector as tosector,tBI.deptTime,tBI.arrivalTime,tB.RiyaPNR ,tBI.cabin          
 ,tB.TotalDiscount, tB.inserteddate,(isnull(tb.FlatDiscount,0) + isnull(tb.PromoDiscount,0)) as FlatDiscount,tB.FareType,tB.returnFlag          
 From tblBookMaster tB           
 left join tblBookItenary tBI on tBI.fkBookMaster = tB.pkId          
 WHERE tB.RiyaPNR = @RiyaPNR          
 order by tBi.deptTime              
 --Travel details             
            
 --farebasis,airlinePNR,cabin             
 SELECT DISTINCT tB.pkId, farebasis,airlinePNR,cabin,tB.ROE,tB.FareType from tblBookItenary tBI             
 left join tblBookMaster tB  on tB.pkId = tBI.fkBookMaster            
 WHERE tB.RiyaPNR =@RiyaPNR            
 order by tB.pkId            
 --farebasis,airlinePNR,cabin             
            
 --Fare Details            
  select DISTINCT(B.frmsector +'-'+ B.tosector)  as sector, (totalFare + isnull(b.MCOAmount,0) + isnull(b.AgentMarkup,0) + isnull(b.ServiceFee,0) + isnull(b.GST,0) + isnull(b.bfc,0)) as totalFare,totalTax,             
 (basicFare + isnull(b.AgentMarkup,0)) as basicFare,(isnull(TotalDiscount,0) + isnull(FlatDiscount,0) + isnull(PromoDiscount,0)) as TotalDiscount,             
 'ServiceCharge: ' + convert(varchar(10),ServiceCharge) + ' YRTax:' + convert(varchar(10),isnull(YRTax,0))            
 +  ' INTax:' + convert(varchar(10),isnull(INTax,0)) +  ' JNTax:' + convert(varchar(10),isnull(JNTax,0))            
  +  ' OCTax :' + convert(varchar(10),isnull (OCTax,0)) +  ' ExtraTax:' + convert(varchar(10),isnull(ExtraTax,0))             
 +   ' YQTax :' + convert(varchar(10),isnull(YQTax,0))  as taxdesc,I.farebasis,b.pkId,cast(isnull((B.AgentMarkup/b.ROE),0) as decimal(10,2)) as AgentMarkup            
 ,B.FareType ,B.ROE ,B.AgentROE, isnull(B.B2BMarkup,0) as B2BMarkup,ISNULL(AOI.Currency,'INR') AS Currency,B.MCOAmount    ,B.ServiceFee,B.GST,(CASE WHEN B.basicFare > 0 THEN B.bfc ELSE 0 END)  as bfc        
   from tblBookMaster B            
    LEFT JOIN tblAmadeusOfficeID AOI ON AOI.OfficeID=B.OfficeID  and AOI.CountryCode=B.Country           
   left join tblBookItenary I ON I.fkBookMaster=B.pkId where  B.RiyaPNR = @RiyaPNR              
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
--select order_id,tracking_id,order_status,payment_mode,card_name,             
--mer_amount, CardNumber,ExpiryDate, CVV, CardType from Paymentmaster     
--where order_id in (select orderid from tblBookMaster where riyaPNR=@riyaPNR)            
            
select distinct(order_id),tracking_id,order_status,payment_mode,card_name, isnull(mer_amount,0) mer_amount,            
--CONVERT (DECIMAL(18,10),mer_amount)/ b.ROE as mer_amount,             
CardNumber,ExpiryDate, CVV, CardType,currency,b.FareType,b.ROE,b.AgentROE            
 from Paymentmaster p            
inner join tblBookMaster b on b.orderid=p.order_id            
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
   
 select ssr.SSR_Type, sum( ssr.SSR_Amount) as SSRAmount       
  from tblSSRDetails(nolock) ssr  
  inner join tblBookMaster(nolock) B ON B.pkId= ssr.fkBookMaster           
  WHERE  b.riyaPNR = @RiyaPNR    
  GROUP BY ssr.SSR_Type  

  --Travel details for Sabre Hold Issuance by Satya         
SELECT distinct tB.pkId,tB.airName+'-'+ tb.flightNo as airname, tb.airCode,tb.flightNo, tB.frmSector as frmsector ,tB.toSector as tosector,tB.deptTime,tB.arrivalTime,tB.RiyaPNR ,tB.VendorName,isnull(tBI.cabin,'NA') cabin,tB.TotalDiscount,        
 tB.inserteddate,(isnull(tb.FlatDiscount,0) + isnull(tb.PromoDiscount,0)) as FlatDiscount,tB.FareType, tB.returnFlag       
 From tblBookMaster tB         
 full outer join tblBookItenary tBI on tBI.fkBookMaster = tB.pkId         
 WHERE tB.GDSPNR= @GDSPNR AND tB.RiyaPNR = @RiyaPNR        
 --order by tBi.deptTime       
 --Travel details  
              
END            



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchRefundAndCancellationNew] TO [rt_read]
    AS [dbo];

