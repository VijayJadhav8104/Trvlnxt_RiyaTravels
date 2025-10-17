
CREATE Procedure [dbo].[Sp_SaveRescheduleData]

@pid nvarchar(30),
@Pkid nvarchar(30),
@FlightNo nvarchar(30),
@Origin nvarchar(20),
@Destination nvarchar(20),
@DepartureDate nvarchar(30),
@Class nvarchar(30),
@RescheduleDate nvarchar(30),
@RescheduleClass nvarchar(30),
@RescheduleFlightNo nvarchar(30),
@ContactNo nvarchar(30),
@Email nvarchar(30),
@Remarks nvarchar(200),
--@Status int,
@RescheduleBackEnduser int,
@ReschedulebyAgency int,
@OrderId nvarchar(50),
@RiyaPNR nvarchar(50),
@NewPKid int,
@IsReturnJourney varchar(10)

as
begin
if(@RescheduleBackEnduser>0)
begin
insert into RescheduleData (pid,Pkid,FlightNo,Origin,Destination,DepartureDate,Class,RescheduleDate,RescheduleClass,RescheduleFlightNo,ContactNo,
Email,Remarks,Status,RescheduleBackEnduser,ReschedulebyAgency,OrderId,CreatedDate,RiyaPNR,NewPKid,IsReturnJourney)
values
(@pid,@Pkid,@FlightNo,@Origin,@Destination,@DepartureDate,@Class,@RescheduleDate,@RescheduleClass,@RescheduleFlightNo,@ContactNo,
@Email,@Remarks,'7',@RescheduleBackEnduser,null,@OrderId,GETDATE(),@RiyaPNR,@NewPKid,@IsReturnJourney)

Update tblBookMaster set BookingStatus=7 where riyaPNR=@RiyaPNR
end

else
begin
insert into RescheduleData (pid,Pkid,FlightNo,Origin,Destination,DepartureDate,Class,RescheduleDate,RescheduleClass,RescheduleFlightNo,ContactNo,
Email,Remarks,Status,RescheduleBackEnduser,ReschedulebyAgency,OrderId,CreatedDate,RiyaPNR,NewPKid,IsReturnJourney)
values
(@pid,@Pkid,@FlightNo,@Origin,@Destination,@DepartureDate,@Class,@RescheduleDate,@RescheduleClass,@RescheduleFlightNo,@ContactNo,
@Email,@Remarks,'7',null,@ReschedulebyAgency,@OrderId,GETDATE(),@RiyaPNR,@NewPKid,@IsReturnJourney)

Update tblBookMaster set BookingStatus=7 where riyaPNR=@RiyaPNR
end

end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_SaveRescheduleData] TO [rt_read]
    AS [dbo];

