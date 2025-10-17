-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- GetROEWithMarkup 'SELECT','','DFG','ADS','23','','','',''  
-- =============================================  
CREATE PROCEDURE GetROEWithMarkup  
 -- Add the parameters for the stored procedure here  
    @Action VARCHAR(10)  
      ,@Id INT = NULL  
      ,@FromCurrency varchar(50)= NULL  
   ,@ToCurrency varchar(50)= NULL  
   ,@Markup decimal(18, 6)= 0  
   --,@TotalAmount decimal(18, 2)= 0  
   ,@CreateDate datetime = NULL  
   ,@CreatedBy int= NULL  
   ,@ModifiedDate datetime = NULL  
   ,@ModifiedBy int= NULL  
  
AS  
BEGIN  
   
 --SELECT  
    IF @Action = 'SELECT'  
      BEGIN  
  
   select RO.Id  
   ,RO.FromCurrency  
   ,RO.ToCurrency  
   ,RO.Markup  
   ,RO.IsActive  
   ,ROE as 'ROERate',  
  
 --  ROE * RO.Markup as markupROE  
  
  -- sum(CAST(ROE * RO.Markup AS decimal(18,6))+CAST(ROE AS decimal(18,6))) as Total  
   cast((cast(isnull(RO.Markup,0.0) as float) + cast(isnull(ROE,0.0) as float)) as float) as Total 
  
      from BBHotelROEWithMarkup RO  
   full join ROE on RO.FromCurrency=ROE.FromCur and RO.ToCurrency=ROE.ToCur  
   where RO.IsActive=1 and ROE.IsActive=1  and ro.FromCurrency='INR'
   group by  RO.Id,RO.FromCurrency,RO.ToCurrency,RO.Markup,RO.IsActive,ROE  
             
  
      END  
   
      --INSERT  
    IF @Action = 'INSERT'  
      BEGIN  
         if not exists( select FromCurrency,ToCurrency from BBHotelROEWithMarkup where FromCurrency=@FromCurrency and ToCurrency=@ToCurrency and IsActive=1)  
            INSERT INTO BBHotelROEWithMarkup(FromCurrency, ToCurrency,Markup,CreateDate,CreatedBy)  
            VALUES (@FromCurrency, @ToCurrency,@Markup,@CreateDate,@CreatedBy)  
      END  
   
      --UPDATE  
    IF @Action = 'UPDATE'  
      BEGIN  
            UPDATE BBHotelROEWithMarkup  
            SET Markup = @Markup, ModifiedDate=@ModifiedDate, ModifiedBy=@ModifiedBy  
            WHERE Id = @Id  
      END  
   
      --DELETE  
    IF @Action = 'DELETE'  
      BEGIN  
           UPDATE BBHotelROEWithMarkup  
            SET IsActive = 0  
            WHERE Id = @Id  
      END  
  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetROEWithMarkup] TO [rt_read]
    AS [dbo];

