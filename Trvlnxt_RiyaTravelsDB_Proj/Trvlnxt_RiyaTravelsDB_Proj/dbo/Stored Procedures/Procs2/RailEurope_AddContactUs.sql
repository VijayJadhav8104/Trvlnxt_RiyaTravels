CREATE proc [dbo].[RailEurope_AddContactUs] 
(     @Name varchar(100),     @MobileNo varchar(50),     @email varchar(50),     @city varchar(50)= NULL, 
@services varchar(50),     @additionalDetails varchar(500)= NULL,     @createDate datetime,     @PageName varchar(200)=NULL  ,   @PaxCount varchar(50)=NULL  ,   @TravelDate varchar(50)=NULL   )  

as begin    
insert into tblContactUs ([Name],MobileNo,email,city,[services],additionalDetails,createDate,PageName,PaxCount,TravelDate)   

values     (@Name,@MobileNo,@email,@city,@services,@additionalDetails,@createDate,@PageName, @PaxCount, @TravelDate)     end