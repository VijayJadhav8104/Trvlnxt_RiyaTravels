  
--exec [dbo].[GetROEWithMarkupAndFlat] 'SELECT'  
CREATE PROCEDURE [dbo].[GetROEWithMarkupAndFlat]  
 -- Add the parameters for the stored procedure here  
 @Action VARCHAR(10)  
 ,@Id INT = NULL  
 ,@FromCurrency varchar(50)= NULL  
 ,@ToCurrency varchar(50)= NULL  
 ,@Markup decimal(18, 6)= 0  
 ,@MarkupType varchar(50)= NULL  
 ,@CreateDate datetime = NULL  
 ,@CreatedBy int= NULL  
 ,@ModifiedDate datetime = NULL  
 ,@ModifiedBy int= NULL  
 ,@Products varchar(50)=NULL  
 ,@UserTypeId int=NULL  
 ,@UserId int = NULL  
 ,@IsAddSubtract int = NULL  
 ,@MarkupAmount Decimal(18,6)=NULL  
 ,@FinalROE Decimal(18,6)=NULL  
 ,@RecordCount int= null output  
AS  
BEGIN  
 IF @Action = 'SELECT'  
 BEGIN  
  declare @UserType varchar(500)  
  select @UserType=stuff((SELECT ',' + cast(usr.UserTypeId as varchar(10)) FROM mUserTypeMapping AS usr  where usr.UserId=@UserId and usr.IsActive=1 FOR XML PATH('') ), 1, 1, '')  
  SELECT  
  (CASE RO.MarkupType   
   WHEN 'PERCENTAGE' THEN ROE * RO.MarkupData/100 + ROE  
   WHEN 'FLAT' THEN ROE + RO.MarkupData END) AS 'Total'  
  --CASE RO.MarkupType WHEN 'PERCENTAGE' THEN CAST(ROE * RO.MarkupData/100 AS FLOAT)+CAST(ROE AS FLOAT)  
  --WHEN 'FLAT' THEN CAST(ROE AS FLOAT)+CAST(RO.MarkupData AS FLOAT) END 'Total'   
  ,RO.Id  
  ,RO.FromCurrency  
  ,RO.ToCurrency  
  ,ROE  
  ,RO.IsActive  
  ,cusr.FullName as CreatedBy  
  ,FORMAT(RO.CreateDate, 'dd-MMM-yyyy') as 'CreateDate'  
  ,musr.FullName as ModifiedBy  
  ,FORMAT(RO.ModifiedDate, 'dd-MMM-yyyy') as 'ModifiedDate'
  ,RO.MarkupType  
  ,RO.MarkupData  
  ,RO.Products  
  ,RO.IsAddSubtract  
  ,RO.MarkupAmount  
  ,RO.FinalROE  
  ,usrt.Value AS UserType  
  FROM ROEWithMarkupAndFlat RO  
  FULL JOIN ROE ON RO.FromCurrency=ROE.FromCur AND RO.ToCurrency=ROE.ToCur  
  LEFT JOIN mUser cusr on ro.CreatedBy=cusr.ID  
  LEFT JOIN mUser musr on ro.ModifiedBy=musr.ID  
  LEFT JOIN mCommon usrt on ro.UserTypeId=usrt.ID   
  WHERE RO.IsActive=1 AND ROE.IsActive=1  
  and RO.UserTypeId IN (select Data from sample_split(@UserType,','))  
  order by CreateDate desc  
  --AND RO.UserTypeId=@UserTypeId  
  --GROUP BY  RO.Id,RO.FromCurrency,RO.ToCurrency,RO.IsActive,ROE,RO.MarkupData,RO.CreateDate,RO.CreatedBy,RO.ModifiedBy,RO.ModifiedDate,RO.MarkupData,Ro.MarkupType,RO.Products  
 END  
        
 --INSERT  
    IF @Action = 'INSERT'  
    BEGIN  
  --IF NOT EXISTS(SELECT FromCurrency,ToCurrency FROM ROEWithMarkupAndFlat WHERE FromCurrency=@FromCurrency and ToCurrency=@ToCurrency and UserTypeId=@UserTypeId and MarkupData=@Markup and IsActive=1)  
  IF NOT EXISTS(SELECT FromCurrency,ToCurrency FROM ROEWithMarkupAndFlat WHERE FromCurrency=@FromCurrency and ToCurrency=@ToCurrency and UserTypeId=@UserTypeId and IsActive=1   
      AND EXISTS (SELECT 1 FROM dbo.SplitString(Products,',') WHERE Item IN (SELECT Item FROM dbo.SplitString(@Products,','))))  
  BEGIN  
   INSERT INTO ROEWithMarkupAndFlat(FromCurrency, ToCurrency,Products,MarkupType,MarkupData,CreateDate,CreatedBy,UserTypeId,IsAddSubtract,MarkupAmount,FinalROE)  
            VALUES (@FromCurrency, @ToCurrency,@Products,@MarkupType,@Markup,@CreateDate,@CreatedBy,@UserTypeId,@IsAddSubtract,@MarkupAmount,@FinalROE)  
  
   INSERT INTO ROELogHistory(FromCurrency,ToCurrency,Products,UserType,MarkupType,MarkupData,InsertedDate,InsertedBy)  
            VALUES (@FromCurrency, @ToCurrency,@Products,@UserTypeId,@MarkupType,@Markup,@CreateDate,@CreatedBy)  
   SET @RecordCount=1  
  
  END  
  ELSE  
  BEGIN  
   SET @RecordCount=0  
  END  
 END  
   
    --UPDATE  
 IF @Action = 'UPDATE'  
 BEGIN  
  IF NOT EXISTS(SELECT FromCurrency,ToCurrency FROM ROEWithMarkupAndFlat WHERE FromCurrency=@FromCurrency and ToCurrency=@ToCurrency and UserTypeId=@UserTypeId and IsActive=1 and Id!=@Id  
      AND EXISTS (SELECT 1 FROM dbo.SplitString(Products,',') WHERE Item IN (SELECT Item FROM dbo.SplitString(@Products,','))))  
  BEGIN  
   INSERT INTO ROEWithMarkupAndFlatHistory  
    (  
    Action  
    , MarkupID  
    , Products  
    , UserTypeId  
    , FromCurrency  
    , ToCurrency  
    , MarkupType  
    , MarkupData  
    , IsAddSubtract  
    , IsActive  
    , CreatedBy  
    , CreateDate  
    , ModifiedBy  
    , ModifiedDate  
    , MarkupAmount  
    , FinalROE  
    )   
   SELECT   
    'Update'  
    , @Id  
    , MAF.Products  
    , MAF.UserTypeId  
    , MAF.FromCurrency  
    , MAF.ToCurrency  
    , MAF.MarkupType  
    , MAF.MarkupData  
    , MAF.IsAddSubtract  
    , MAF.IsActive  
    , MAF.CreatedBy  
    , MAF.CreateDate  
    , MAF.ModifiedBy  
    , MAF.ModifiedDate  
    , MAF.MarkupAmount  
    , MAF.FinalROE  
   FROM ROEWithMarkupAndFlat MAF   
   WHERE Id=@Id  
  
   UPDATE ROEWithMarkupAndFlat  
   SET MarkupType=@MarkupType, MarkupData = @Markup, ModifiedDate=@ModifiedDate, ModifiedBy=@ModifiedBy,Products=@Products,UserTypeId=@UserTypeId,IsAddSubtract=@IsAddSubtract, MarkupAmount=@MarkupAmount, FinalROE=@FinalROE  
   WHERE Id = @Id   
  
   INSERT INTO ROELogHistory(FromCurrency, ToCurrency,Products,UserType,MarkupType,MarkupData,InsertedDate,InsertedBy)  
   VALUES (@FromCurrency, @ToCurrency,@Products,@UserTypeId,@MarkupType,@Markup,@ModifiedDate,@ModifiedBy)  
  
   SET @RecordCount=1  
  END  
  ELSE  
  BEGIN  
   SET @RecordCount=0  
  END  
    END  
   
    --DELETE  
    IF @Action = 'DELETE'  
    BEGIN  
  INSERT INTO ROEWithMarkupAndFlatHistory  
    (  
    Action  
    , MarkupID  
    , Products  
    , UserTypeId  
    , FromCurrency  
    , ToCurrency  
    , MarkupType  
    , MarkupData  
    , IsAddSubtract  
    , IsActive  
    , CreatedBy  
    , CreateDate  
    , ModifiedBy  
    , ModifiedDate  
    , MarkupAmount  
    , FinalROE  
    )   
   SELECT   
    'Update'  
    , @Id  
    , MAF.Products  
    , MAF.UserTypeId  
    , MAF.FromCurrency  
    , MAF.ToCurrency  
    , MAF.MarkupType  
    , MAF.MarkupData  
    , MAF.IsAddSubtract  
    , MAF.IsActive  
    , MAF.CreatedBy  
    , MAF.CreateDate  
    , MAF.ModifiedBy  
    , MAF.ModifiedDate  
    , MAF.MarkupAmount  
    , MAF.FinalROE  
   FROM ROEWithMarkupAndFlat MAF   
   WHERE Id=@Id  
  UPDATE ROEWithMarkupAndFlat SET IsActive = 0 WHERE Id = @Id  
    END  
END