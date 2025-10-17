CREATE Procedure Proc_InsertBookingAPIReqAndResp    
@APIController Varchar(500)=null,    
@Request varchar(Max)=null,    
@Response Varchar(Max)=null,    
@bookingRefId varchar(500)=null    
As    
Begin     
 Insert Into [AllAppLogs].[dbo].HotelAPI_RequestResponsetbl(APIController,Request,Response,InsertedDate,StatusID)    
 Values(@APIController,@Request,@Response,GETDATE(),@bookingRefId)    
End