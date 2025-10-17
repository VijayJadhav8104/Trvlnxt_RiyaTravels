CREATE PROCEDURE [dbo].[FetchPGReportData]    
 @frmDate datetime=NULL    
 , @toDate datetime=NULL    
AS    
BEGIN    
 --select DISTINCT(T.GDSPNR), T.inserteddate as 'BookingDate',P.getway_name,P.order_id,P.tracking_id,P.order_status,    
 --P.mer_amount, P.payment_mode,T.riyaPNR,I.airlinePNR  from tblBookMaster T    
 --INNER JOIN Paymentmaster P ON P.order_id=T.orderId    
 --INNER JOIN tblBookItenary I on I.orderId=T.orderId    
 --where  CONVERT(date,T.inserteddate) >= CONVERT(date,@frmDate)    
 --   AND CONVERT(date,T.inserteddate) <= CONVERT(date,@toDate)    
 --   order by T.inserteddate desc    
 IF(@toDate !=null)    
 BEGIN    
  SELECT    
  inserteddt    
  , tracking_id    
  , order_status    
  , T.riyaPNR    
  , T.GDSPNR    
  , t.orderid    
   ,ISNULL(TFBookingRef,'') AS 'RiyaConnectPNR'  
  FROM Paymentmaster P WITH(NOLOCK)    
  INNER JOIN tblBookMaster T WITH(NOLOCK) ON T.orderId=P.order_id    
  WHERE CONVERT(date,inserteddt) >= CONVERT(date,@frmDate)    
  AND CONVERT(date,inserteddt) <= CONVERT(date,@toDate)    
 END    
 ELSE    
 BEGIN    
  SELECT    
  inserteddt    
  , tracking_id    
  , order_status    
  , T.riyaPNR    
  , T.GDSPNR    
  , t.orderid   
  ,ISNULL(TFBookingRef,'') AS 'RiyaConnectPNR'  
  FROM Paymentmaster P WITH(NOLOCK)    
  INNER JOIN tblBookMaster T WITH(NOLOCK) ON T.orderId = P.order_id    
  WHERE CONVERT(date,inserteddt) >= CONVERT(date,@frmDate)    
 END    
      
 SELECT    
 DISTINCT(T.riyaPNR)    
 , T.GDSPNR    
 , T.orderid    
 , isnull(T.IsBooked,0) as 'IsBooked'    
 , p.Iscancelled    
 , p.IsRefunded    
 , M.FullName AS UserName    
 , OfficeID    
 , BI.airlinePNR    
 , t.airName     
 ,(CASE WHEN (LG.IsSSOUser = 1) THEN 'Staff'    
    WHEN LG.IsSSOUser IS NULL OR LG.IsSSOUser = '' THEN 'B2C'    
    ELSE 'B2C'    
    END) AS 'Source'    
 ,LG.UserName as Booked_By    
 ,ISNULL(T.ServiceFee,0) AS 'ServiceFee'    
 ,ISNULL(T.GST,0) AS 'GST'    
 ,ISNULL(TotalCommission,0) AS 'TotalCommission'    
 ,ISNULL(GSTOnPGCharge,0) AS 'GSTOnPGCharge'  
 ,ISNULL(TFBookingRef,'') AS 'RiyaConnectPNR'  
 from tblBookMaster T WITH(NOLOCK)    
 INNER JOIN tblPassengerBookDetails p WITH(NOLOCK) ON p.fkBookMaster=t.pkId    
 INNER JOIN tblBookItenary BI WITH(NOLOCK) ON BI.orderId=T.orderId     
 LEFT JOIN CancellationHistory CH WITH(NOLOCK) ON CH.OrderId=T.orderid AND FlagType=2    
 LEFT JOIN adminMaster M WITH(NOLOCK) ON M.Id=CH.UpdatedBy    
 LEFT JOIN Userlogin LG WITH(NOLOCK) ON T.LoginEmailID =CONVERT(VARCHAR(50),LG.UserID)    
 LEFT JOIN B2BMakepaymentCommission PC WITH(NOLOCK) ON T.pkId=PC.FkBookId    
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchPGReportData] TO [rt_read]
    AS [dbo];

