--Proc_GetCancelationreport 20726,0,'2023-07-01','2023-08-08'  
Create procedure Proc_GetSummeryReport 
@AgentId int = 0 ,          
@MainAgentId int = 0,      
@FromDate varchar(100)='',      
@ToDate varchar(100)=''  
As
Begin
	if @ToDate in ('',NULL)                                                              
		set @ToDate = DATEADD(DAY,1,@FromDate)                                                              
	else 
		set @ToDate = DATEADD(DAY,1,@ToDate)  
	
	Select   
		HB.inserteddate As TransactionDate,
		HM.Status as BookingType,
		HB.CheckInDate as CheckInDate,
		HB.CheckOutDate as CheckOutDate,
		HB.BookingReference As BookingId,
		isnull(HB.providerConfirmationNumber,0) as VoucherId,
		'Hotel' As ServiceType,
		HB.LeaderFirstName+' '+HB.LeaderLastName as PaxName,
		case when tbs.TranscationAmount is null then tbla.TranscationAmount end as TransactionAmount,
		case when tbs.OpenBalance is null then tbla.OpenBalance end as OpenBalance, 
		case when tbs.CloseBalance is null then tbla.CloseBalance end as ClosingBalance, 
		case when tbs.TransactionType is null then tbla.TransactionType end CreditOrDebit,
		HB.CurrencyCode as Currency
		from Hotel_BookMaster HB                                                                          
			join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId                                                      
			join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                                                                                                                    
			left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1          
			left join Hotel_BookingGSTDetails HBG on HBG.PKID=HB.pkId    
			left join tblSelfBalance tbs on tbs.BookingRef=HB.orderId and  tbs.UserID=HB.MainAgentID  
			left join tblAgentBalance tbla on tbla.BookingRef=HB.orderId and  tbla.AgentNo=HB.RiyaAgentID 
		    where (HB.RiyaAgentID=@AgentId or (HB.MainAgentID=@MainAgentId and HB.MainAgentID >0))          
			and HB.BookingPortal = 'TNH'          
			and HB.RiyaAgentID is not null                                                                                                             
			and HH.IsActive=1
			and HH.FkStatusId=7
			and ((Convert(date,HB.inserteddate) >= Convert(date,@FromDate) and Convert(date,HB.inserteddate) < @ToDate) or @FromDate='')      
		order by HB.inserteddate ASC         
End