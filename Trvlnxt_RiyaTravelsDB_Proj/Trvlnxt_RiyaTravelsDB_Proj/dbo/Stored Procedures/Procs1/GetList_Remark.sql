
CREATE proc [dbo].[GetList_Remark]

@OrderID varchar(50)

as
begin

	select
		PKID,
		OrderId,
		GDSPNR,
		AgentHistory.UserId,
		Remark,
		IP,
		InsertDate,
		ISNULL((SELECT FullName FROM adminMaster WHERE adminMaster.Id=AgentHistory.UserId),
		 (SELECT FirstName +' '+ LastName FROM AgentLogin WHERE AgentLogin.UserID=AgentHistory.UserId))  as Name
	from AgentHistory
	--left join UserLogin on UserLogin.UserID = AgentHistory.UserId
	where OrderId= @OrderID

end







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_Remark] TO [rt_read]
    AS [dbo];

