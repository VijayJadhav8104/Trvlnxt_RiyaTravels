CREATE PROCEDURE [dbo].[sp_GetAgencyDetailsByID_18122023] --[sp_GetAgencyDetailsByID] 45007             
 @ID INT    
AS    
BEGIN    
 DECLARE @ParentID INT    
    
 SELECT @ParentID = ParentAgentID    
 FROM AgentLogin(NOLOCK)    
 WHERE UserID = @ID    
    
 DECLARE @BaseCurrency VARCHAR(50)    
 DECLARE @Currency VARCHAR(50)    
 DECLARE @roe DECIMAL(18, 16)    
 DECLARE @usertype VARCHAR(10)    
 DECLARE @country VARCHAR(2)    
    
 IF (@ParentID IS NULL)    
 BEGIN    
  SELECT @BaseCurrency = C.Currency,@Currency = (    
    CASE     
     WHEN curr.Value IS NULL    
      THEN C.Currency    
     ELSE curr.Value    
     END    
    )    
   ,@roe = (isnull(AL.ROE, 1))    
   ,@country = AL.BookingCountry    
   ,@usertype = co.Value    
  FROM AgentLogin(NOLOCK) AL    
  INNER JOIN mCountry(NOLOCK) C ON C.CountryCode = AL.BookingCountry    
  LEFT JOIN mCommon(NOLOCK) curr ON Al.NewCurrency = cast(curr.ID AS VARCHAR(6))    
  INNER JOIN mCommon(NOLOCK) CO ON CO.ID = AL.UserTypeID    
  WHERE USERID = @ID    
 END    
 ELSE    
 BEGIN    
  SELECT @BaseCurrency = C.Currency,@Currency = (    
    CASE     
     WHEN curr.Value IS NULL    
      THEN C.Currency    
     ELSE curr.Value    
     END    
    )    
   ,@roe = (isnull(AL.ROE, 1))    
   ,@country = AL.BookingCountry    
   ,@usertype = co.Value    
  FROM AgentLogin(NOLOCK) AL    
  INNER JOIN mCountry(NOLOCK) C ON C.CountryCode = AL.BookingCountry    
  LEFT JOIN mCommon(NOLOCK) curr ON Al.NewCurrency = cast(curr.ID AS VARCHAR(6))    
  INNER JOIN mCommon(NOLOCK) CO ON CO.ID = AL.UserTypeID    
  WHERE USERID = @ParentID    
 END    
    
 IF (@BaseCurrency = @Currency)    
 BEGIN    
  SELECT @Currency = Currency,@roe = ROE    
  FROM mAgentROE(NOLOCK)    
  WHERE IsActive = 1    
   AND UserType = @usertype    
   AND Country = @country    
   AND AgencyID LIKE '%' + cast(@ID AS VARCHAR(100)) + '%'    
   AND IsDeleted = 0    
    
  IF (@BaseCurrency = @Currency)    
  BEGIN    
   SELECT @Currency = Currency,@roe = ROE    
   FROM mAgentROE(NOLOCK)    
   WHERE IsActive = 1    
    AND UserType = @usertype    
    AND Country = @country    
    AND agencyid = CAST(0 AS VARCHAR(MAX))    
    AND IsDeleted = 0    
  END    
 END    
    
 IF (@ParentID IS NULL)    
 BEGIN    
  SELECT UserID    
   ,BookingCountry    
   ,B.AgencyName    
   ,B.Icast    
   ,isnull(FirstName + ' ' + LastName, UserName) 'DisplayName'    
   ,ISNULL(AL.AgentBalance, 0) AS AgentBalance    
   ,--* isnull(AL.ROE,1) as AgentBalance                
   ISNULL(@roe,1) AS ROE    
   ,@BaseCurrency AS BaseCurrency    
   ,@Currency AS Currency    
   ,CM.CategoryValue AS OfficeID    
   ,B.Icast    
   ,B.AddrMobileNo    
   ,B.AddrEmail    
   ,B.BranchCode    
   ,AL.FirstName    
   ,AL.LastName    
   ,AL.MobileNumber    
   ,AL.HomeNo    
   ,AL.Address    
   ,AL.City    
   ,AL.Country    
   ,NM.Code AS 'AgentNationality'    
   ,NM.Nationality AS 'AgentNationalityText'    
   ,AL.Pincode    
   ,AL.Province    
   ,AL.UserName    
   ,ISNULL(AL.AgentApproved, 0) AS AgentApproved    
   ,ISNULL(B.STATUS, 0) AS STATUS    
   ,ISNULL(B.AutoTicketing, 0) AS AutoTicketing    
   ,isnull(ParentAgentID, 0) AS ParentAgentID    
   ,CO.ID AS UserType    
   ,AL.BalanceUpdateDate    
   ,CASE     
    WHEN isnull(B.AddrLandlineNo, '   ') <> ''    
     AND isnull(B.AddrMobileNo, '') <> ''    
     THEN isnull(Replace(B.AddrLandlineNo, '+', ''), '') + '/' + isnull(Replace(B.AddrMobileNo, '+', ''), '')    
    WHEN isnull(B.AddrLandlineNo, '') <> ''    
     AND isnull(B.AddrMobileNo, '') = ''    
     THEN isnull(Replace(B.AddrLandlineNo, '+', ''), '')    
    WHEN isnull(B.AddrLandlineNo, '') = ''    
     AND isnull(B.AddrMobileNo, '') <> ''    
     THEN isnull(Replace(B.AddrMobileNo, '+', ''), '')    
    ELSE ''    
    END AS CrypticContactNo    
   ,B.PaymentMode    
   ,ISNULL(AL.GroupId,0) as GroupID    
   ,ISNULL(AL.NoERP,0) AS NoErp    
  FROM AgentLogin(NOLOCK) AL    
  LEFT JOIN B2BRegistration(NOLOCK) B ON B.FKUserID = al.UserID    
  LEFT JOIN mCountry(NOLOCK) C ON C.CountryCode = AL.BookingCountry    
  LEFT JOIN tbl_commonmaster(NOLOCK) CM ON CM.Country = AL.BookingCountry    
   AND CM.UserTypeID IN (    
    SELECT UserTypeID    
    FROM agentLogin(NOLOCK)    
    WHERE USERID = @ID    
    )    
  LEFT JOIN Hotel_Nationality_Master(NOLOCK) NM ON AL.BookingCountry = NM.ISOCode    
   AND NM.ISOCode IS NOT NULL    
  INNER JOIN mCommon(NOLOCK) CO ON CO.ID = AL.UserTypeID    
  LEFT JOIN mCommon(NOLOCK) curr ON Al.NewCurrency = cast(curr.ID AS VARCHAR(6))    
  WHERE UserID = @ID    
  --and NM.ISOCode is not null              
  --and CM.Category = 'officeid'               
  ORDER BY CM.Mapping ASC    
 END    
 ELSE    
  SELECT UserID    
   ,BookingCountry    
   ,B.AgencyName    
   ,B.Icast    
   ,(    
    SELECT isnull(FirstName + ' ' + LastName, UserName)    
    FROM AgentLogin(NOLOCK) AL    
    WHERE USERID = @ID    
    ) AS 'DisplayName'    
   --,(select FullName from mUser where id=@MainID )AS 'DisplayName'                
   ,ISNULL(AL.AgentBalance, 0) AS AgentBalance    
   ,--* isnull(AL.ROE,1) as AgentBalance                
   ISNULL(@roe,1) AS ROE    
   ,@BaseCurrency AS BaseCurrency    
   ,@Currency AS Currency    
   ,CM.CategoryValue AS OfficeID    
   ,B.Icast    
   ,B.AddrMobileNo    
   ,B.AddrEmail    
   ,B.BranchCode    
   ,AL.FirstName    
   ,AL.LastName    
   ,AL.MobileNumber    
   ,AL.HomeNo    
   ,AL.Address    
   ,AL.City    
   ,AL.Country    
   ,NM.Code AS 'AgentNationality'    
   ,NM.Nationality AS 'AgentNationalityText'    
   ,AL.Pincode    
   ,AL.Province    
   ,AL.UserName    
   ,ISNULL(AL.AgentApproved, 0) AS AgentApproved    
   ,ISNULL(B.STATUS, 0) AS STATUS    
   --,ISNULL(B.AutoTicketing, 0) AS AutoTicketing                
   ,(    
    SELECT isnull(AutoTicketing, 0)    
    FROM AgentLogin(NOLOCK) AL    
    WHERE USERID = @ID    
    ) AS AutoTicketing    
   ,(    
    SELECT isnull(ParentAgentID, 0)    
    FROM AgentLogin(NOLOCK) AL    
    WHERE USERID = @ID    
    ) AS ParentAgentID    
   ,CO.ID AS UserType    
   ,AL.BalanceUpdateDate    
   ,CASE     
    WHEN isnull(B.AddrLandlineNo, '') <> ''    
     AND isnull(B.AddrMobileNo, '') <> ''    
     THEN isnull(Replace(B.AddrLandlineNo, '+', ''), '') + '/' + isnull(Replace(B.AddrMobileNo, '+', ''), '')    
    WHEN isnull(B.AddrLandlineNo, '') <> ''    
     AND isnull(B.AddrMobileNo, '') = ''    
     THEN isnull(Replace(B.AddrLandlineNo, '+', ''), '')    
    WHEN isnull(B.AddrLandlineNo, '') = ''    
     AND isnull(B.AddrMobileNo, '') <> ''    
     THEN isnull(Replace(B.AddrMobileNo, '+', ''), '')    
    ELSE ''    
    END AS CrypticContactNo    
   ,B.PaymentMode    
   ,ISNULL(AL.GroupId,0) as GroupID    
   ,ISNULL(AL.NoERP,0) AS NoErp    
  FROM AgentLogin(NOLOCK) AL    
  LEFT JOIN B2BRegistration(NOLOCK) B ON B.FKUserID = al.UserID    
  INNER JOIN mCountry(NOLOCK) C ON C.CountryCode = AL.BookingCountry    
  LEFT JOIN tbl_commonmaster(NOLOCK) CM ON CM.Country = AL.BookingCountry    
   AND CM.UserTypeID IN (    
    SELECT UserTypeID    
    FROM agentLogin(NOLOCK)    
    WHERE USERID = @ID    
    )    
  LEFT JOIN Hotel_Nationality_Master(NOLOCK) NM ON AL.BookingCountry = NM.ISOCode    
   AND NM.ISOCode IS NOT NULL    
  INNER JOIN mCommon(NOLOCK) CO ON CO.ID = AL.UserTypeID    
  LEFT JOIN mCommon(NOLOCK) curr ON Al.NewCurrency = cast(curr.ID AS VARCHAR(6))    
  WHERE FKUSERID = @ParentID    
  --and NM.ISOCode is not null              
  --and CM.Category = 'officeid'             
  ORDER BY CM.Mapping ASC    
    
 IF (@ParentID IS NULL)    
 BEGIN    
  SELECT LocationCode    
  FROM B2BRegistration(NOLOCK)    
  WHERE FKUserID = @ID    
 END    
 ELSE    
 BEGIN    
  SELECT LocationCode    
  FROM B2BRegistration(NOLOCK)    
  WHERE FKUserID = @ParentID    
 END    
  
  --For Allow Booking  
 select   
 Product,case AllowBooking when 1 then 'true' else 'false' end  as AllowBooking-- 'AllowBooking')  
from AgentRights   
where FKAgencyId=@ID     
  
END