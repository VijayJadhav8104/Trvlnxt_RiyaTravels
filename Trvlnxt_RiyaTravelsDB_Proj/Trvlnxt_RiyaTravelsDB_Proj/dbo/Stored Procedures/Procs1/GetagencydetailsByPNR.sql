create PROCEDURE GetagencydetailsByPNR 
	-- Add the parameters for the stored procedure here
@airlinepnr varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select distinct AgentID,AddrEmail,riyaPNR from tblBookMaster 
join B2BRegistration on AgentID=fkuserid
where 
GDSPNR=@airlinepnr
--GDSPNR='8BIJGQ'
END
