
-------------------------------                              
--Created By Ketan Hiranandani                      
--Reason:For Getting All users data which is reporting to particular user                      
--usp_Get_Reporting_AccountUser 0 
--usp_Get_Reporting_AccountUser 99                     
-------------------------------                              
                              
CREATE PROCEDURE [dbo].[usp_Get_Reporting_AccountUser]                                  
@USER_ID INT                                   
                             
AS                                   
BEGIN                      
                          
IF @USER_ID=0 OR @USER_ID=16            
              
BEGIN              
SELECT 'All Users' AS FIRST_NAME,-1 AS USER_ID                        
UNION ALL                      
SELECT FIRST_NAME,USER_ID FROM TUR_GLO_MST_USERS WHERE isactive=1 AND D_Type=294              
              
END                                
END 



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_Get_Reporting_AccountUser] TO [rt_read]
    AS [dbo];

