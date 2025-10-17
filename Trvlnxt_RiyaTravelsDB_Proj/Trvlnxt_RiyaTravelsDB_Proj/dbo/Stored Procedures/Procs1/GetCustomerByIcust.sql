CREATE PROC GetCustomerByIcust
	@ICUST VARCHAR(MAX)=''
AS
BEGIN
	SET NOCOUNT ON;

	Select * from tblICust Where (ICust=@ICUST OR @ICUST='') AND (IsDone!=1 OR IsDone IS NULL)
END
