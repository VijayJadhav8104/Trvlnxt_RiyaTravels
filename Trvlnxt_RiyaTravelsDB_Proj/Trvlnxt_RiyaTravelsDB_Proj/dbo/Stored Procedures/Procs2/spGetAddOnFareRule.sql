CREATE Proc [dbo].[spGetAddOnFareRule]  
AS  
BEGIN  
  
 --Select * from mFareType where IsActive=1   
  
 Select  ft.*, com.value as CabinV  from mFareType ft  
left join mCommon com on ft.Cabin=CONVERT(varchar,com.ID)  
where IsActive=1 and Blocked=0   
  
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetAddOnFareRule] TO [rt_read]
    AS [dbo];

