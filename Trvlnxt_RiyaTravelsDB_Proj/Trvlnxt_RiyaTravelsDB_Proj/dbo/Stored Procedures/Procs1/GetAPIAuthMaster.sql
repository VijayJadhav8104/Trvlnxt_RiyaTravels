--GetAPIAuthMaster '',0,0,0  
CREATE PROC GetAPIAuthMaster  
 @APIKey VARCHAR(MAX)=''  
 ,@AgentId INT=0  
 ,@ID INT=0  
 ,@IsInternal INT  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 IF(@ID=0)  
 BEGIN  
  SELECT * FROM 
  (    SELECT A.Id,APIKey,B.Icast,B.AgencyName, IPAddress,A.Status AS 'Status', 
   A.Availability,A.Sell,A.Booking,
  'No' AS Internal,0 AS IsInternal, A.InsertedDate,     
  U.UserName AS CreatedBy,UM.UserName AS UpdatedBy,UpdatedOn    
  FROM APIAuthenticationMaster A  
   WITH(NOLOCK)    
   LEFT JOIN B2BRegistration B WITH(NOLOCK) ON A.AgentID = B.FKUserID    
   LEFT JOIN mUser U WITH(NOLOCK) ON A.CreatedBy=U.ID   
   LEFT JOIN mUser UM WITH(NOLOCK) ON A.UpdatedBy=UM.ID    
   WHERE (@APIKey = '' OR APIKey = @APIKey)    
   AND (@AgentId = 0 OR AgentID = @AgentId)        ) AS FirstPart   
   UNION ALL    
   SELECT * FROM 
   (    SELECT A.Id,APIKey,B.Icast,B.AgencyName, IPAddress,A.Status AS 'Status',
    A.Availability,A.Sell,A.Booking,
   'Yes' AS Internal,1 AS IsInternal, A.InsertedDate,    U.UserName AS CreatedBy,
   UM.UserName AS UpdatedBy,UpdatedOn    
   FROM APIAuthenticationMaster_Internal A WITH(NOLOCK)    
   LEFT JOIN B2BRegistration B WITH(NOLOCK) ON A.AgentID = B.FKUserID    
   LEFT JOIN mUser U WITH(NOLOCK) ON A.CreatedBy=U.ID    
   LEFT JOIN mUser UM WITH(NOLOCK) ON A.UpdatedBy=UM.ID   
  
   WHERE (@APIKey = '' OR APIKey = @APIKey)    AND (@AgentId = 0 OR AgentID = @AgentId)        ) AS SecondPart    ORDER BY InsertedDate DESC;  
  
 END  
 ELSE  
 BEGIN  
  IF(@IsInternal=1)  
  BEGIN  
   SELECT A.Id,APIKey,B.AgencyName,A.AgentID, 
   IPAddress,A.Status AS 'Status', 
   'Yes' AS Internal,1 AS IsInternal, A.InsertedDate       
   FROM APIAuthenticationMaster_Internal A WITH(NOLOCK)    
   LEFT JOIN B2BRegistration B WITH(NOLOCK) ON A.AgentID = B.FKUserID       WHERE Id=@ID  
  END  
  ELSE  
  BEGIN  
   SELECT A.Id,APIKey,B.AgencyName,A.AgentID, IPAddress,A.Status AS 'Status', 'Yes' AS Internal,0 AS IsInternal, A.InsertedDate       FROM APIAuthenticationMaster A WITH(NOLOCK)    
   LEFT JOIN B2BRegistration B WITH(NOLOCK) ON A.AgentID = B.FKUserID       
   WHERE Id=@ID  
  END  
 END  
   
   
END  