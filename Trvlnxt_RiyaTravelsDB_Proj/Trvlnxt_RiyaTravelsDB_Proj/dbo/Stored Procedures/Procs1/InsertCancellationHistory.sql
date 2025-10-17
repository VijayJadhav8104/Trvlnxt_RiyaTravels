CREATE PROCEDURE [dbo].[InsertCancellationHistory]
@OrderID			varchar(30)=null,
@RiyaPNR			varchar(10)=null,
@FlagType			VARCHAR(50)=null,
@Panelty			DECIMAL(18,0)=null,
@Remark				varchar(500)=null,
@UpdatedBy			int=null,
@RefundId			varchar(30)=null,
@RefundAmount		int=null,
@GDSPNR				varchar(10)=null,
@trackingid			varchar(30)=null,
@CancellationCharge	int=null,	
@ServiceCharge		int=null,
@Discount			int=null,
@paxfname			varchar(50)=null,
@paxtype			varchar(50)=null,
@totalfare			decimal=null,
@sector				varchar(50)=null,
@returnflag			bit=null,
@HistoryID			varchar(50)=null,
@TotalRefund		int=null	
AS BEGIN
	if (@RefundId='0')
	begin
	set @RefundId=null
	end
		

    if (@FlagType='1')--PROCESS FOR REFUND
		begin

			INSERT INTO CancellationHistory(OrderId,RiyaPNR, FlagType,Panelty,Remark, UpdatedBy,RefundId,RefundAmount,GDSPNR,CancellationCharge,ServiceCharge,Discount,paxfname,paxtype,totalfare,sector,returnflag,HistoryID,TotalRefund)
			VALUES(@OrderId,@RiyaPNR, @FlagType,@Panelty, @Remark, @UpdatedBy,@RefundId,@RefundAmount,@GDSPNR,@CancellationCharge,@ServiceCharge,@Discount,@paxfname,@paxtype,@totalfare,@sector,@returnflag,@HistoryID,@TotalRefund)

			 update tblPassengerBookDetails
			 set Iscancelled=0, IsRefunded =0, isProcessRefund=1, cancellationRemark=@Remark, Panelty=@Panelty,FailedFlag=0
			 where fkBookMaster in(select pkid from tblBookMaster where riyaPNR=@RiyaPNR AND GDSPNR=@GDSPNR)
		 end
		   else if (@FlagType='3')--cancelclosd
		begin

			INSERT INTO CancellationHistory(OrderId,RiyaPNR, FlagType,Panelty,Remark, UpdatedBy,RefundId,RefundAmount,GDSPNR,CancellationCharge,ServiceCharge,Discount,paxfname,paxtype,totalfare,sector,returnflag,HistoryID,TotalRefund)
			VALUES(@OrderId,@RiyaPNR, 1,@Panelty, @Remark, @UpdatedBy,@RefundId,@RefundAmount,@GDSPNR,@CancellationCharge,@ServiceCharge,@Discount,@paxfname,@paxtype,@totalfare,@sector,@returnflag,@HistoryID,@TotalRefund)

			
		 end
	 else if (@FlagType='2')--refund
	BEGIN
	
			if (@GDSPNR !='' )
				begin
					 update tblPassengerBookDetails
					 set Iscancelled=0, IsRefunded =1, isProcessRefund=0, cancellationRemark=@Remark, Panelty=@Panelty,
					 RefundedDate=getdate(),RefundAmount=@RefundAmount,FailedFlag=0
					 where fkBookMaster in(select pkid from tblBookMaster where riyaPNR=@RiyaPNR AND GDSPNR=@GDSPNR)
				 end

				 else
		 
				 begin
					 update tblPassengerBookDetails
					 set Iscancelled=0, IsRefunded =1, isProcessRefund=0, cancellationRemark=@Remark, Panelty=@Panelty,
					 RefundedDate=getdate(),RefundAmount=@RefundAmount
					 where fkBookMaster in(select pkid from tblBookMaster where riyaPNR=@RiyaPNR)
				 end

if  (@HistoryID !='')
    BEGIN
			insert into CancellationHistory
			(OrderId,RiyaPNR, FlagType,Panelty,Remark, UpdatedBy,RefundId,RefundAmount,GDSPNR,CancellationCharge,ServiceCharge,
			Discount,paxfname,paxtype,totalfare,sector,returnflag,HistoryID,TotalRefund)
			select orderid,riyapnr,@FlagType,Panelty,@Remark,@UpdatedBy,@RefundId,@RefundAmount,GDSPNR,
			CancellationCharge,ServiceCharge,Discount,paxfname,paxtype,totalfare,sector,returnflag,HistoryID,TotalRefund 
			from CancellationHistory where HistoryID=@HistoryID
	END
	ELSE
	BEGIN
	INSERT INTO CancellationHistory(OrderId,RiyaPNR, FlagType,Panelty,Remark, UpdatedBy,RefundId,RefundAmount,GDSPNR,CancellationCharge,ServiceCharge,Discount,paxfname,paxtype,totalfare,sector,returnflag,HistoryID,TotalRefund)
			VALUES(@OrderId,@RiyaPNR, @FlagType,@Panelty, @Remark, @UpdatedBy,@RefundId,@RefundAmount,@GDSPNR,@CancellationCharge,@ServiceCharge,@Discount,@paxfname,@paxtype,@totalfare,@sector,@returnflag,@HistoryID,@TotalRefund)
	END 
			 if not exists(select PKID from Paymentissuance where OrderId=@OrderID)
				 begin
					 insert into Paymentissuance 
					 (Tracking_Id,Amount,OrderId,Status,Remarks)
					 values(@trackingid,@RefundAmount,@OrderID,'Successful','Refunded')
				 end
			 else
				 begin
					 update Paymentissuance
					 set Remarks='Refunded' where OrderId=@OrderID
				 end
      END

	 if (@GDSPNR !='')
		 begin
			 update tblBookMaster
			 set UserID=@UpdatedBy where riyaPNR=@RiyaPNR AND GDSPNR=@GDSPNR
		 end
	 else
		 begin
			  update tblBookMaster
			 set UserID=@UpdatedBy where riyaPNR=@RiyaPNR 
		 end
END










GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertCancellationHistory] TO [rt_read]
    AS [dbo];

