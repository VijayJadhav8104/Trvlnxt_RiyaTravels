CREATE Procedure [dbo].[Get_TFBookingDetails]     
   
As    
Begin    
 
 select OfficeID,VendorName,GDSPNR,journey,TFBookingRef,TFBookingstatus,riyaPNR,orderId,AgentID,tblBookMaster.pkId,tblBookMaster.Country,operatingCarrier,B.AddrEmail
 from tblBookMaster 
 join b2bregistration B on B.FKUserID=AgentID
 where    (VendorName='TravelFusion' or VendorName='TravelFusionNDC') 
 and BookingStatus=16
 --and (TFBookingstatus='BookingInProgress' or TFBookingstatus='Unconfirmed'or TFBookingstatus='UnconfirmedBySupplier') and BookingSource='API'
 
End