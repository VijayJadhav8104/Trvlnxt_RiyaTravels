CREATE PROCEDURE [dbo].[Sp_GetAgentBalance]                 
@FromDate Date=null                  
 , @ToDate Date=null                  
 , @AgentId int=null     
 ,@UserId int = null   
 ,@CountryId varchar(50)  
 ,@UserTypeID int = null  
 as                 
 BEGIN                
select            
FORMAT(ab.CreatedOn, 'dd-MMM-yyyy') as 'DepositDate',        
mb.[name] as BranchName ,r.AgencyName,r.icast as AgentId,                
'Topup Account' as AccountType,        
ab.PaymentMode,        
'Agent Balance Updation' as TransactionType,                
TranscationAmount as CreditAmount,'' as DebitAmount,                
Remark,                
'' as 'Ref No' ,        
mu.UserName as 'TopUpDoneBy'        
FROM tblAgentBalance ab WITH(NOLOCK)                  
  INNER JOIN AgentLogin al WITH(NOLOCK) on al.UserID=ab.AgentNo                  
  INNER JOIN B2BRegistration r WITH(NOLOCK) ON CAST(r.FKUserID AS VARCHAR(50))=ab.AgentNo                  
  LEFT JOIN mBranch mb WITH(NOLOCK) ON r.LocationCode=mb.Code and mb.BranchCode=r.BranchCode         
  LEFT JOIN muser mu WITH(NOLOCK) on ab.CreatedBy=mu.id        
  INNER JOIN mCommon c WITH(NOLOCK) on c.ID=al.UserTypeID        
  INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=al.BookingCountry        
  WHERE ((@FromDate = '') OR (CONVERT(date,ab.CreatedOn) >= CONVERT(date,@FromDate)))                  
   AND ((@ToDate = '') OR  (CONVERT(date,ab.CreatedOn) <= CONVERT(date,@ToDate)))                          
   AND ((@AgentId = '') OR  (ab.AgentNo =CAST(@AgentId AS varchar(50))))   
   AND ((@CountryId = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@CountryId, ','))))   
    AND ((@UserTypeID = '') OR ( AL.UserTypeID in (SELECT cast(Data AS int) FROM sample_split(@UserTypeID, ','))))--Piyush      
  and al.Country in (select c.CountryName from mUserCountryMapping m inner join mcountry c on c.ID=m.CountryId where userid=@UserId and isActive=1)    
and TransactionType='Credit'and bookingref in ('Credit','Check')
and ab.IsActive=1 and IsDeleted=0  and ab.PaymentMode='PaymentGateway'         
order by ab.CreatedOn desc        
END

