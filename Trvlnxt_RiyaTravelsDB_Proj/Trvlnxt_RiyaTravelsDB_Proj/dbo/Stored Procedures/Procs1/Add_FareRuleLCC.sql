CREATE proc [dbo].[Add_FareRuleLCC]

@AirLine varchar(50),
@CancellationFee int,
@CancellationRemark nvarchar(200),
@ReschedullingFee int,
@ReschedullingRemark nvarchar(200),
@Sector varchar(50),
@ProductClass varchar(50),
@OtherCondition nvarchar(max),
@UserName varchar(100),
@UserType varchar(50),
@Country varchar(5)
as
begin


update FareRule
set Status=0, addeddate=getdate(),UserName=@UserName 
where AirLine=@AirLine and Sector=@Sector and ProductClass=@ProductClass
and  UserType= @UserType and Country=@Country and Status=1

insert into FareRule
(

AirLine,
CancellationFee,
CancellationRemark,
ReschedullingFee,
ReschedullingRemark,
Sector,
ProductClass,
OtherCondition,
Status,
AddedDate,
UserName,
UserType,
Country
)
values
(
@AirLine ,
@CancellationFee,
@CancellationRemark ,
@ReschedullingFee ,
@ReschedullingRemark ,
@Sector ,
@ProductClass ,
@OtherCondition,
1,
GETDATE(),
@UserName,
@UserType,
@Country
)

end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Add_FareRuleLCC] TO [rt_read]
    AS [dbo];

