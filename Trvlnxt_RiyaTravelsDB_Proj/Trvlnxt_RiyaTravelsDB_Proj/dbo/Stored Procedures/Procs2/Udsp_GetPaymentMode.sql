
CREATE Procedure [dbo].[Udsp_GetPaymentMode] -- exec Udsp_GetPaymentMode 51375, 'ai','DXBAD3359'
@ID INT,
@AirCode varchar(50) =null,
@officeid varchar(50) =null
AS
BEGIN
declare @ParentID INT
SELECT @ParentID=ParentAgentID FROM AgentLogin WHERE UserID=@ID
declare @val varchar(100)
IF (@ParentID IS NULL)
begin	
set @val =(select PaymentMode from B2BRegistration where FKUserID= @ID)
end
else
begin
set @val =(select PaymentMode from B2BRegistration where FKUserID= @ParentID)
end
DECLARE @checkval varchar(50)
set @checkval=''

if(@AirCode !='' and @officeid!='')
begin
declare @countairline INT
declare @countofficeid INT
	select @countairline=count(1) from tblCreditCardBlock 
	where AirlineCode in (SELECT Data FROM sample_split(@AirCode, ','))  and OfficeID=@officeid
	
	select @countofficeid=count(1) from tblCreditCardBlock where OfficeID=@officeid


	if (@countairline< (SELECT count(Data) FROM sample_split(@AirCode, ','))) and (@countofficeid>1)
	begin
		set @checkval ='Credit Card'
	end
end

select Data,Value from sample_split(@val,',')  s
		inner join mCommon m on s.data = m.ID and Value!=@checkval
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Udsp_GetPaymentMode] TO [rt_read]
    AS [dbo];

