Create Proc [Hotel].GetGstState
AS
BEGIN
select ID,GSTState as 'State' from mGSTState
END