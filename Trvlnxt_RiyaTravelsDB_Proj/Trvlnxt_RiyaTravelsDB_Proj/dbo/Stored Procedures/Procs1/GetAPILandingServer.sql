CREATE PROCEDURE [dbo].[GetAPILandingServer]  
AS  
BEGIN  
 Select top 1 ServerUrl from ApiLanding(nolock) order by ServerHitCounter asc  
   
 ;with cte as (Select top 1 ServerUrl,ServerHitCounter from ApiLanding(nolock) order by ServerHitCounter asc)  
 update cte set ServerHitCounter=ServerHitCounter+1   
  
END   
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAPILandingServer] TO [rt_read]
    AS [dbo];

