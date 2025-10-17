CREATE proc [dbo].[GetIATACodes]
As
Begin
select commoncode,code from iatacode
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetIATACodes] TO [rt_read]
    AS [dbo];

