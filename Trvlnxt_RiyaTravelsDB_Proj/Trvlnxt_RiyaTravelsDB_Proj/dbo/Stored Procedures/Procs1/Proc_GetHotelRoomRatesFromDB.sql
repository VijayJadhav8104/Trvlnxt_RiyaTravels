CREATE procedure Proc_GetHotelRoomRatesFromDB

@token varchar(200)=null,
@MethodName varchar(100)=null
AS

BEGIN

select top 1 * from [AllAppLogs].[dbo].[Hotelapilogs] where Token=@token and MethodName=@MethodName;

END 