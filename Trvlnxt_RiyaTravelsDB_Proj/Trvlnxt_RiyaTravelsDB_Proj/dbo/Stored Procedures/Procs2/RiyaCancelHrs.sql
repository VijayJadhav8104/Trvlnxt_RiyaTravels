--===================================================      
--Created By : Rakesh       
--Creation Date :      
--Modified By : Shivkumar Prajapati      
--Modified Date :      
-- Exec RiyaCancelHrs '33435','hotelbeds','72.53333','05/26/2022'      
--===================================================      
CREATE PROCEDURE RiyaCancelHrs      
      
  @RiyaAgentID NVARCHAR(50)      
 ,@SupplierName NVARCHAR(50)      
  ,@CancelHr float    
 ,@ChInDate varchar(50)      
AS      
BEGIN      
       
 DECLARE @CanHr INT      
 DECLARE @CanDeadDate nvarchar(20)      
 DECLARE @CanDays float    
 DECLARE @CancellationDate nvarchar(50)      
 set @CancellationDate=Convert(varchar,dateadd(day,-0,@ChInDate),0)      
     
IF(@CancelHr>0)      
BEGIN      
  --set @CanDays=@CancelHr/24      
 --set @CanDeadDate =dateadd(HOUR,-@CancelHr,@ChInDate)      
      
 --====================Buffer Time on day=====================      
 --set @CanDeadDate=Convert(varchar,dateadd(day,-0,@CanDeadDate),0)      
 --===========================================================      
    -----NEW ***  
  SET @CanHr = (      
    SELECT CancellationHours      
    FROM AgentSupplierProfileMapper ASPM      
    INNER JOIN b2bHotelSupplierMaster HSM ON ASPM.SupplierId = HSM.Id      
    inner join B2BRegistration BR on ASPM.AgentId=BR.PKID  ----- added Altamash : Agent id missmatch on table      
    WHERE ltrim(rtrim(HSM.SupplierName)) = ltrim(rtrim(@SupplierName))  --ltrim(rtrim('Qtech (LocalSystem)'))      
     AND BR.FKUserID = @RiyaAgentID    ----added altamash : Agent id missmatch on table      
     AND ASPM.IsActive = 1      
     AND HSM.IsActive = 1      
    )  
 -----New ***  
 set @CanDeadDate =dateadd(HOUR,-(ISNULL(@CancelHr,0)+ISNULL(@CanHr,0)),@ChInDate)  
 set @CanDeadDate=Convert(varchar,dateadd(day,-0,@CanDeadDate),0)   
 set @CanDays=(@CancelHr+ISNULL(@CanHr,0))/24  
  
 Select @CanDeadDate as 'CancenllationDeadLine',   
     ISNULL(@CanDays,0) as CancellationDays --, convert(date, @CanDeadDate, 105) AS 'CancenllationDate'      
     ,convert(VARCHAR, dateadd(hour, - 0, @CanDeadDate), 105) AS 'CDate'      
      
END      
      
--==================================================End Cancellation DeadLine========================================================      
       
 IF EXISTS (      
   SELECT TOP (1) *      
   FROM b2bHotelSupplierMaster      
   WHERE ltrim(rtrim(SupplierName)) = ltrim(rtrim(@SupplierName))      
    AND IsActive = 1      
   )      
 BEGIN      
  SET @CanHr = (      
    SELECT CancellationHours      
    FROM AgentSupplierProfileMapper ASPM      
    INNER JOIN b2bHotelSupplierMaster HSM ON ASPM.SupplierId = HSM.Id      
    inner join B2BRegistration BR on ASPM.AgentId=BR.PKID  ----- added Altamash : Agent id missmatch on table      
    WHERE ltrim(rtrim(HSM.SupplierName)) = ltrim(rtrim(@SupplierName))  --ltrim(rtrim('Qtech (LocalSystem)'))      
     AND BR.FKUserID = @RiyaAgentID    ----added altamash : Agent id missmatch on table      
     AND ASPM.IsActive = 1      
     AND HSM.IsActive = 1      
    )      
 END      
 ELSE      
 BEGIN      
  SET @CanHr = (      
    SELECT 0      
    )      
 END      
      
  
 Select @CancellationDate;  
 --if exists(select convert(varchar, dateadd(hour, - @CanHr, @CancellationDate), 100) AS 'CancellationDate'       
 --  , convert(varchar, dateadd(hour, - @CanHr, @CancellationDate), 105) AS 'CancellationDate'       
 SELECT convert(VARCHAR, dateadd(hour, - @CanHr, @CancellationDate), 100) AS 'CancellationDate'      
    ,convert(VARCHAR, dateadd(hour, - @CanHr, @CancellationDate), 105) AS 'CancellationDates'      
    ,convert(VARCHAR, dateadd(hour, - @CanHr, @CancellationDate), 103) AS 'CDate'      
      
      
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[RiyaCancelHrs] TO [rt_read]
    AS [dbo];

