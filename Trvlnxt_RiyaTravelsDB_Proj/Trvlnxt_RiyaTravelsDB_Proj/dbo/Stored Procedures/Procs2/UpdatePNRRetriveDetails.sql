CREATE proc [dbo].[UpdatePNRRetriveDetails]  
  
@GDSPNR varchar(10),  
@RiyaPNR nvarchar(10),  
@OfficeId varchar(100),  
@OrderId nvarchar(100),  
@GstAmount decimal(18,2)=0.0,  
@ServiceFee decimal(18,2)=0.0  
As  
BEGIN  
  
Update PNRRetriveDetails set ServiceFee = @ServiceFee,GSTAMount = @GstAmount,InsertedDate = getdate()  
where GDSPNR = @GDSPNR and RiyaPNR = @RiyaPNR and OfficeId = @OfficeId and OrderID = @OrderId  
  
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdatePNRRetriveDetails] TO [rt_read]
    AS [dbo];

