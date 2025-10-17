CREATE PROCEDURE [dbo].[sp_GetAgencyNames_1]          
 @GroupId VARCHAR(255) = null         
AS             
BEGIN      
 SELECT PKID      
   , AgencyName      
   , CustomerCOde      
   , FKUserID       
 FROM B2BRegistration WITH(NOLOCK)      
 WHERE FKUserID IN (SELECT userid      
      FROM AgentLogin WITH(NOLOCK)       
      Where groupid  IN (SELECT Data FROM sample_split(@GroupId, ','))      
      and GroupId in(3,9,18,6,4,34))      
      
END