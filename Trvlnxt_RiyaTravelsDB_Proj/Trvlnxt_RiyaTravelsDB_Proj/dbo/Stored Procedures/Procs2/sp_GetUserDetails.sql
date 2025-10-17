          
CREATE procedure sp_GetUserDetails           
AS          
Begin          
Select mu.ID,FullName,UserName,EmployeeNo as EmployeeCode,MobileNo,          
EmailId,ml.LocationName,mr.RoleName,        
md.DepartmentName,mc.CountryName, mco.[Value] As UserType,                 
AutoTicketing,agentBalance,SelfBalance,CancelRequest,        
GhostTrack,mu.ContractCommission,
(SELECT STRING_AGG(ag.GroupName, ',')          
FROM muser mu1          
OUTER APPLY sample_Split(mu1.NewGroupid, ',') ss         
LEFT JOIN mAgentGroup ag ON ag.id = CAST(ss.data AS INT)          
WHERE ag.id IS NOT NULL AND mu1.id = mu.id  -- Ensure we match the current row          
GROUP BY mu1.id) AS GroupNames,      
(SELECT STRING_AGG(muo.OfficeId, ',')          
FROM mUserOfficeIdMapping muo                
WHERE muo.UserId = mu.id  -- Ensure we match the current row          
GROUP BY muo.userid) As OfficeId,    
loginfromcountry ,       
FORMAT(mu.createdon, 'dd-MMM-yyyy') as 'createdon',mu.createdBy,FORMAT(mu.ModifiedOn, 'dd-MMM-yyyy') as 'ModifiedOn',        
isnull(mu.ModifiedBy,0) as ModifiedBy,mu.isActive,FORMAT(lastlogindate, 'dd-MMM-yyyy') as 'lastlogindate'        
 from muser mu          
 left join mlocation ml on ml.id=mu.LocationID and ml.Status=1          
 left join mDepartment md on md.ID=mu.DepartmentID and md.Status=1          
 left join mCountry mc on mc.ID=mu.CountryID           
 left join mrole mr on mr.ID=mu.RoleID          
 left join mCommon mco on mco.id=mu.UserTypeId and mco.Category='UserType'  
 End    
  
  