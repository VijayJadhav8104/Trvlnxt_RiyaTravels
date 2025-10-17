

CREATE PROCEDURE [dbo].[InsertPromoHistory]
@FromSector varchar(50),
@ToSector varchar(50),
@FromDate datetime,
@ToDate datetime,
@UserType int,
@TripType char(1),
@Browser varchar(50)=null,
@Device varchar(50)=null,
@IP varchar(50)=null,
@PromoCode varchar(50),
@SessionID VARCHAR(50)=null,
@EmailID varchar(50)=null,
@Userid int,
@Url varchar(100)=null,
@Status int

AS BEGIN
INSERT INTO PromoHistory 
(
FromSector,
ToSector,
FromDate ,
ToDate ,
UserType ,
TripType ,
Browser ,
Device ,
IP ,
PromoCode ,
SessionID ,
EmailID ,
Userid,
Url,
status 
)

values
(
@FromSector,
@ToSector,
@FromDate ,
@ToDate ,
@UserType ,
@TripType ,
@Browser ,
@Device ,
@IP ,
@PromoCode ,
@SessionID ,
@EmailID ,
@Userid,
@Url,
@Status 
)

END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertPromoHistory] TO [rt_read]
    AS [dbo];

