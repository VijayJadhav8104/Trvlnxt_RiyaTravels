
Create Procedure Sp_GetIndicatorOfficeID
as
begin
select OfficeID,Indicator from tblOwnerCurrency
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetIndicatorOfficeID] TO [rt_read]
    AS [dbo];

