                                        
CREATE procedure [dbo].[API_OriginalReissuePnrDetails] -- API_HoldPNRDetails 'TNA8MO4FA9'                                        
@RiyaPNR varchar(50) = ''          
,@OriginalOrdeID varchar(100) = ''
,@TripType varchar(20) = ''
                                        
as 
begin                                        
                                        
if(@TripType != 'RB')
begin
	Select b.OfficeID ,b.JourneySellKey as ValidatingCarrier, b.GDSPNR,b.orderId,b.AgentID,b.VendorName,b.ROE,b.Country,b.AgentCurrency,p.amount,b.B2BMarkup,b.IsBooked,b.BookingStatus,b.APITrackID,b.totalFare, b.TFBookingRef, b.JourneySellKey,b.pkId,b.riyaPNR
   
	,b.returnFlag,b.B2bFareType        
          
	,(select Sum(SSR_Amount) From tblSSRDetails where tblSSRDetails.fkBookMaster = b.pkId and tblSSRDetails.SSR_Code != 'null' and tblSSRDetails.SSR_Code != '') as SSRTotalFare        
	,(select top 1 Airlinepnr from tblBookItenary where orderId = b.orderId  and airlinePNR != 'null' and airlinePNR != '') as Airlinepnr                          
	from tblBookMaster as b WITH (NOLOCK)                                         
	inner join Paymentmaster as p on b.orderId = p.order_id                                        
	where b.riyaPNR = @RiyaPNR           
	and b.orderId = @OriginalOrdeID          
	and totalFare > 0                                
                                            
	Select pid,ISNULL(paxFName,'') as 'paxFName',ISNULL(paxLName,'') as 'paxLName',ISNULL(paxType,'') as 'paxType',TicketNumber,isReturn,totalFare,B2bMarkup,MarkupOnTaxFare,ParentB2BMarkup                              
	from tblPassengerBookDetails where fkBookMaster IN (select pkId from tblBookMaster where riyaPNR = @RiyaPNR and orderId = @OriginalOrdeID)                                               
                                
	select ROW_NUMBER() OVER (ORDER BY Itenary.pkId) - 1 as ID,Itenary.pkId,Itenary.fkBookMaster,Itenary.airlinePNR,Itenary.orderId,Itenary.frmSector,Itenary.toSector, Itenary.isReturnJourney                            
	from tblBookItenary as Itenary                            
	where Itenary.fkBookMaster IN (select pkId from tblBookMaster where riyaPNR = @RiyaPNR and orderId = @OriginalOrdeID)                             
	
end
else
begin
	Select b.OfficeID ,b.JourneySellKey as ValidatingCarrier, b.GDSPNR,b.orderId,b.AgentID,b.VendorName,b.ROE,b.Country,b.AgentCurrency,p.amount,b.B2BMarkup,b.IsBooked,b.BookingStatus,b.APITrackID,b.totalFare, b.TFBookingRef, b.JourneySellKey,b.pkId,b.riyaPNR   
	,b.returnFlag,b.B2bFareType
	,(select Sum(SSR_Amount) From tblSSRDetails where tblSSRDetails.fkBookMaster = b.pkId and tblSSRDetails.SSR_Code != 'null' and tblSSRDetails.SSR_Code != '') as SSRTotalFare        
	,(select top 1 Airlinepnr from tblBookItenary where orderId = b.orderId  and airlinePNR != 'null' and airlinePNR != '') as Airlinepnr                          
	from tblBookMaster as b WITH (NOLOCK)                                         
	inner join Paymentmaster as p on b.orderId = p.order_id                                        
	where b.riyaPNR = @RiyaPNR           
	and b.BookingStatus = '1'    
	and totalFare > 0                                
                                            
	Select pid,ISNULL(paxFName,'') as 'paxFName',ISNULL(paxLName,'') as 'paxLName',ISNULL(paxType,'') as 'paxType',TicketNumber,isReturn,totalFare,B2bMarkup,MarkupOnTaxFare,ParentB2BMarkup                              
	from tblPassengerBookDetails where fkBookMaster IN (select pkId from tblBookMaster where riyaPNR = @RiyaPNR and BookingStatus = '1')                                               
                                
	select ROW_NUMBER() OVER (ORDER BY Itenary.pkId) - 1 as ID,Itenary.pkId,Itenary.fkBookMaster,Itenary.airlinePNR,Itenary.orderId,Itenary.frmSector,Itenary.toSector, Itenary.isReturnJourney                            
	from tblBookItenary as Itenary                            
	where Itenary.fkBookMaster IN (select pkId from tblBookMaster where riyaPNR = @RiyaPNR and BookingStatus = '1')
end 

end
