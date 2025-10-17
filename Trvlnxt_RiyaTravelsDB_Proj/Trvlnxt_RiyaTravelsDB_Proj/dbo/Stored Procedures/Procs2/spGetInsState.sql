CREATE proc [dbo].[spGetInsState]
as
begin
select stateName,stateCode,CountryCode from [dbo].[tblInsState] where CountryCode='USA'

order by stateName ASC
end