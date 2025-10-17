CREATE proc [Hotel].GetHotelRoeMarkUpValue  -- [Hotel].GetHotelRoeMarkUpValue 'INR','USD' 
 @FromCurr varchar(20)=''
,@ToCurr Varchar(20)=''

AS

BEGIN 
  
    Select top 1 id,FromCurrency,ToCurrency,TotalAmount,IsActive from BBHotelROEWithMarkup 
	where FromCurrency=@FromCurr and ToCurrency=@ToCurr and IsActive=1

END