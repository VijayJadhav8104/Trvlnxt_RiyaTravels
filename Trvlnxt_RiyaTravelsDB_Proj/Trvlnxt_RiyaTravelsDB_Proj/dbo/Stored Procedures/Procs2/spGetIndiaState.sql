create proc [dbo].[spGetIndiaState]
as
begin

select state as stateName ,stateCode from tblStateCode order by stateName ASC

end
