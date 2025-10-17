
CREATE Proc [dbo].[FetchCurrentAgentBalance] --'367',null,null,null,1
@ID int=null,
@AgencyName varchar(800)=null,
@Icust varchar(800)=null,
@AddrLandlineno varchar(800)=null,
@ISConsole int=0
AS BEGIN
	IF(@ISConsole=0)
	begin
	declare @ParentAgentID  int=null
		--SELECT CloseBalance FROM tblAgentBalance where AgentNo=@ID AND IsActive=1
		

		SELECT @ParentAgentID=ParentAgentID  FROM AgentLogin where UserID=@ID

		if (@ParentAgentID !='')
		begin
		SELECT ISNULL(AgentBalance, 0)  AS AgentBalance  FROM AgentLogin where UserID=@ParentAgentID
		end
		else
		begin
		SELECT ISNULL(AgentBalance, 0)  AS AgentBalance  FROM AgentLogin where UserID=@ID
		end

end
	ELSE
		
			SELECT ISNULL(AgentBalance, 0)  AS AgentBalance , ISNULL(R.CreditLimit, 0)  AS CreditLimit
				FROM AgentLogin U
				JOIN B2BRegistration R 
				ON U.UserID=R.FKUserID
			WHERE 
				UserID=@ID
					

		
			select AgencyName, 
				   CreatedOn,
				   TranscationAmount,
				   isnull(CloseBalance,0) as Total,
				   TransactionType,
				   AddrLandlineNo,Remark,Reference
			FROM tblAgentBalance T 
			INNER JOIN B2BRegistration B 
			on 
			b.PKID=t.AgentNo
			where 
				t.AgentNo=@ID

				select 
					AgencyName,
					Icast,
					AddrLandlineNo
				FROM B2BRegistration B		
				where 
				FKUserID=@ID
		
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchCurrentAgentBalance] TO [rt_read]
    AS [dbo];

