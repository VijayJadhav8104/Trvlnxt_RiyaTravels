CREATE proc [dbo].[InsertPNRRetriveDetails]

@GDSPNR varchar(10),
@AgentName nvarchar(max),
@OfficeId varchar(100),
@LoginId varchar(10),
@TicketIssue bit,
@RiyaPNR nvarchar(12),
@OrderId nvarchar(100),
@empcode nvarchar(50)=null,
@CostCenterSwonNo nvarchar(50)=null,
@TRPONoREQNO nvarchar(50)=null,
@CorpEmpCode VARCHAR(50)=NULL,
@Endorsementline VARCHAR(50)=NULL,
@GstAmount decimal(18,2)=0.0,
@ServiceFee decimal(18,2)=0.0
As
BEGIN

declare @pkid varchar(10)

select @pkid=PKID from B2BRegistration where FKUserID=@LoginId

insert into PNRRetriveDetails(GDSPNR,AgentName,OfficeId,LoginId,TicketIssue,RiyaPNR,OrderID,insertedDate,
empcode,CostCenterSwonNo,TRPONoREQNO,CorpEmpCode,Endorsementline,GSTAMount,ServiceFee) 
values(@GDSPNR,@pkid,@OfficeId,@LoginId,@TicketIssue,@RiyaPNR,@OrderId,getdate(),
@empcode,@CostCenterSwonNo,@TRPONoREQNO,@CorpEmpCode,@Endorsementline,@GstAmount,@ServiceFee)
select SCOPE_IDENTITY()

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertPNRRetriveDetails] TO [rt_read]
    AS [dbo];

