--=======================  
--created By : Akash/Nitish   
--created Date  : 31 may 2022  
--Description : to get roe value by passing fromcur and Tocur  
  
--[GetRoe_ConsoleAPI] 'USD','INR'   
--=======================  
  
CREATE PROCEDURE [dbo].[GetRoe_ConsoleAPI]   
@FromCurr varchar(20),  
@ToCurr varchar(20)  
AS  
BEGIN  
 SELECT ROE AS ROEValue FROM ROE WHERE FromCur=@FromCurr AND ToCur=@ToCurr AND IsActive=1  
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRoe_ConsoleAPI] TO [rt_read]
    AS [dbo];

