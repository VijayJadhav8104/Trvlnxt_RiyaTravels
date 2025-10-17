Create Procedure [Cruise].[Sp_GetToken]
AS
Begin
Select top(1) * From cruise.CordilaCruiseToken order by ID desc
end
