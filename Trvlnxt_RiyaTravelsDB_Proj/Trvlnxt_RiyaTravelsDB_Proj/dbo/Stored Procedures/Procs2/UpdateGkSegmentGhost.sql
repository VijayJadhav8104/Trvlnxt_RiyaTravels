CREATE proc [dbo].[UpdateGkSegmentGhost]

@OrderId nvarchar(100),
@gdspnr varchar(50)=null
As
BEGIN

Update tblBookMaster set IsGhost = 1 ,
GDSPNR=@gdspnr
where orderid = @OrderId
select SCOPE_IDENTITY()

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateGkSegmentGhost] TO [rt_read]
    AS [dbo];

