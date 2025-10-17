CREATE Procedure [dbo].[SP_AgentListLowBalanceCheck]
AS
BEGIN

 SELECT UserID, 500000 as LowBalLimit,'Air' as FType,UserName FROM AgentLogin WHERE UserName IN ('Riyaconnect')
 UNION 
 SELECT UserID, 3000000 as LowBalLimit,'Air' as FType,UserName FROM AgentLogin WHERE UserName IN ('ADHCUST14081947')
  UNION 
 SELECT UserID, 100000 as LowBalLimit, 'Hotel' as FType,UserName FROM AgentLogin WHERE UserName IN ('rbtcliq')
 UNION 
 SELECT UserID, 500000 as LowBalLimit, 'Hotel' as FType,UserName FROM AgentLogin WHERE UserName IN ('H19R322')
  UNION 
 SELECT  UserID, 25000 as LowBalLimit, 'AirCustomise' as FType,UserName
 FROM AgentLogin 
 WHERE GroupId in (4) and IsActive = 1 and Country='USA'
 UNION
 SELECT  UserID, 25000 as LowBalLimit, 'AirCustomise' as FType,UserName
 FROM AgentLogin 
 WHERE GroupId in (4) and IsActive = 1 and Country='UNITED KINGDOM'
END 