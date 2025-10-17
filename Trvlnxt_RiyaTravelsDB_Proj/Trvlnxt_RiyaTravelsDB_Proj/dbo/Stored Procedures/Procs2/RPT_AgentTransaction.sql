    
CREATE Procedure [dbo].[RPT_AgentTransaction]        
 @p_dtFromDate Date        
 ,@p_dtToDate Date        
 ,@p_sPNR varchar(30) =''        
 ,@p_sTicketNo varchar(100) =''        
 ,@p_sAirlineInQuery varchar(max) =''        
 ,@Country varchar(40)=''        
 ,@AgentType varchar(50)=''        
 ,@AgentId int=''        
 ,@p_sPaymentMode varchar(30)=''        
AS        
BEGIN        
        
        
 select        
 UPPER(FORMAT(tbm.IssueDate, 'dd-MMM-yyyy HH:mm:ss')) as [Transaction Date],        
 isnull(brs.Icast,brs1.Icast) as [Cust Id],        
 tbm.BookingSource as [Transaction Source],        
 (CASE WHEN (tbm.BookingStatus =1  and tbm.IsBooked=1) THEN 'Confirmed' ELSE 'Cancelled' END) as [Booking Status],        
 tbm.riyaPNR as [Riya PNR],        
 (select top 1 airlinePNR from tblBookItenary BI WHERE BI.fkBookMaster=tbm.pkId) as [Supplier PNR],        
 tbm.GDSPNR  as [CRS PNR],        
 tpb.TicketNumber as [Ticket No],        
 tbm.airCode as [Airline Code],        
 tbm.frmSector + '-' + tbm.toSector as Sector,        
 tpb.title+' '+  tpb.paxFName + ' ' + tpb.paxLName as [Passenger Name],        
 --tpb.basicFare as [Base Amount],         
 --tpb.YQ as [YQ Tax],        
 --tpb.totalTax as [Taxes Charges],        
      
 CONVERT(decimal(18,2),tpb.basicFare*tbm.ROE) as [Base Amount],         
 CONVERT(decimal(18,2),tpb.YQ*tbm.ROE) as [YQ Tax],        
 CONVERT(decimal(18,2),(tpb.totalTax-tpb.YQ)*tbm.ROE) as [Taxes Charges],        
 (CONVERT(decimal(18,2),(tpb.totalTax-tpb.YQ)*tbm.ROE) +tpb.ServiceFee+tpb.GST+tpb.Markup+tpb.BFC+tpb.B2BMarkup) as [Taxes ChargesUI],        
        
 CONVERT(DECIMAL(18,2),ISNULL(((dbo.Get_SSR_Amount_By_SSR_TypeWithoutGroupby (tbm.riyaPNR,tbm.pkId,'Baggage',tpb.totalFare,tpb.paxType,tpb.paxFName,paxLName))        
      * (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=tbm.pkId)),0)        
  + ISNULL(((dbo.Get_SSR_Amount_By_SSR_TypeWithoutGroupby (tbm.riyaPNR,tbm.pkId,'Seat',tpb.totalFare,tpb.paxType,tpb.paxFName,paxLName))        
      * (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=tbm.pkId)),0)        
  + ISNULL(((dbo.Get_SSR_Amount_By_SSR_TypeWithoutGroupby (tbm.riyaPNR,tbm.pkId,'Meals',tpb.totalFare,tpb.paxType,tpb.paxFName,paxLName))        
      * (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=tbm.pkId)),0)) AS [SSR Amount],        
      
 tpb.ServiceFee as [Service Fee - SF],        
 tpb.GST as [GST On Service Fee],        
 --tpb.Markup as [Mark Up],        
 CONVERT(DECIMAL(18,2),(ISNULL(tpb.B2BMarkup,0))) AS 'Hidden Markup',    
 (CASE WHEN (tpb.MarkOn IS NULL OR tpb.MarkOn='Markup on Base') THEN ISNULL(tpb.BFC,0) ELSE 0 End) AS 'Markup on fare',    
 (CASE WHEN tpb.MarkOn='Markup on Tax' THEN ISNULL(tpb.BFC,0) ELSE 0 End) AS 'Markup on tax',    
 tpb.BFC as [BFC],        
      
 CONVERT(DECIMAL(18,2),((tpb.totalFare * tbm.ROE)+ tpb.Markup + tpb.BFC + tpb.ServiceFee + tpb.GST +        
  ISNULL(((dbo.Get_SSR_Amount_By_SSR_TypeWithoutGroupby (tbm.riyaPNR,tbm.pkId,'Baggage',tpb.totalFare,tpb.paxType,tpb.paxFName,paxLName))        
      * (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=tbm.pkId)),0)        
  + ISNULL(((dbo.Get_SSR_Amount_By_SSR_TypeWithoutGroupby (tbm.riyaPNR,tbm.pkId,'Seat',tpb.totalFare,tpb.paxType,tpb.paxFName,paxLName))        
      * (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=tbm.pkId)),0)        
  + ISNULL(((dbo.Get_SSR_Amount_By_SSR_TypeWithoutGroupby (tbm.riyaPNR,tbm.pkId,'Meals',tpb.totalFare,tpb.paxType,tpb.paxFName,paxLName))        
      * (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=tbm.pkId)),0) +        
  (ISNULL(tpb.B2BMarkup,0)) -        
  (isnull(tpb.IATACommission,0) + isnull(tpb.PLBCommission,0) + isnull(tpb.DropnetCommission,0)))) AS [Gross Amount],      
        
 --tpb.totalFare as [Gross Amount],        
 tpb.FMCommission  as [Commission],        
 tpb.CancellationCharge as [Cancellation Charges],        
 bmc.TotalCommission as [PG Charges],        
 pm.payment_mode as [Payment Mode],        
      
 --tpb.B2BMarkup as [Agency Markup],        
 CONVERT(DECIMAL(18,2),(isnull(tbm.ServiceFeeMap,0) + isnull(tbm.ServiceFeeAdditional,0))) as [Agency Markup]      
      
 ,tbm.Remarks as [Remarks],       
       
 tpb.MCOTicketNo as [MCO Number],       
       
 isnull(brs.AgencyName,brs1.AgencyName) as [Agency Name],        
      
 case when tbm.journey ='O' then  'OneWay' when tbm.journey ='R' then 'Return'  else 'Multicity' end as [Journey Type],       
       
 case when  tbm.CounterCloseTime =1 then  'Domestic' else  'International'  end as [Trip Type]       
       
 from tblPassengerBookDetails tpb        
 inner join tblBookMaster tbm WITH(NOLOCK)  ON tpb.fkBookMaster=tbm.pkId        
 LEFT JOIN agentLogin al WITH(NOLOCK) ON CAST(al.UserID AS VARCHAR(50))=tbm.AgentID         
 left join B2BRegistration brs WITH(NOLOCK) ON brs.FKUserID=al.UserID         
 left join B2BRegistration brs1 WITH(NOLOCK) ON brs1.FKUserID= CAST(al.ParentAgentID AS VARCHAR(50))         
 left join  Paymentmaster pm WITH(NOLOCK) ON tbm.orderId=pm.order_id        
 --left join tblSSRDetails tsd on tbm.pkId=tsd.fkBookMaster        
 left join B2BMakepaymentCommission bmc WITH(NOLOCK) ON tbm.pkId=bmc.FkBookId        
 where        
 ((tbm.BookingStatus =1  and tbm.IsBooked=1) OR (tbm.BookingStatus=4 OR tbm.BookingStatus=6 OR tbm.BookingStatus=11))        
 and tpb.totalFare>0 and AgentID!='B2C'        
 and ((@p_dtFromDate='') or (@p_dtFromDate=null) or CONVERT(date, @p_dtFromDate)<= convert(date,tbm.IssueDate))        
 and ((@p_dtToDate ='') or (@p_dtToDate =null) or CONVERT(date,@p_dtToDate)>=convert(date,tbm.IssueDate))        
 and (@p_sPNR='' or @p_sPNR is null or tbm.GDSPNR = @p_sPNR OR tbm.riyaPNR = @p_sPNR         
  OR (select top 1 airlinePNR from tblBookItenary BI WHERE BI.fkBookMaster=tbm.pkId)=@p_sPNR)        
 and (@p_sTicketNo='' or @p_sTicketNo is null or tpb.TicketNumber like '%'+@p_sTicketNo+'%')        
 and ((@p_sAirlineInQuery='' or  @p_sAirlineInQuery is null) or (LOWER(tbm.airName) in(select LOWER(Data) from sample_split(@p_sAirlineInQuery,','))))        
 AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ','))))         
 AND ((@AgentId = '' or @AgentId = 0 or tbm.AgentID in (select UserID from AgentLogin where ParentAgentID = @AgentID and ParentAgentID is not null)) OR (tbm.AgentID =CAST(@AgentId AS varchar(50))))         
 and (@p_sPaymentMode='' or @p_sPaymentMode='ALL' or pm.payment_mode=@p_sPaymentMode)          
AND (
            @AgentType = ''
            OR EXISTS (
                SELECT 1
                FROM sample_split(@AgentType, ',') s
                WHERE
                    TRY_CAST(s.Data AS INT) = al.UserTypeID
                    OR EXISTS (
                        SELECT 1
                        FROM mCommon m
                        WHERE m.Value = s.Data AND m.ID = al.UserTypeID
                    )
            )
        )
    ORDER BY tbm.IssueDate
        
End 