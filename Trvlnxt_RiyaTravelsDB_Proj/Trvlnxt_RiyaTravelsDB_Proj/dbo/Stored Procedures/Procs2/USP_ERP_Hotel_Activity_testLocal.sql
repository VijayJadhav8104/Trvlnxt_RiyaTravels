--sp_helptext USP_ERP_Hotel_Activity_testLocal 'Hotel_WinYatraBooking'                
--=================================                
                          -- select convert( varchar(15),GEtdate(),100)--'2025-03-26 18:26:09.793' as date)
-- =============================================                                                                          
-- Author:  Rahul A                                                                     
-- Create date: 28 Mar 2022    
-- Description: ERP Activity                                                                  
-- =============================================                                                                  
--[USP_ERP_Hotel_Activity] 'Hotel_WinYatraBooking','','',''                                                                  
CREATE PROCEDURE [dbo].USP_ERP_Hotel_Activity_testLocal                                                                   
 @Action varchar(50)='Hotel_WinYatraBooking',                                                                  
 @empcode varchar(50) =null,                                                                  
 @Hotel_ERPResponceID varchar(500) = null,                                                                  
@Hotel_CanERPResponceID varchar(500) = null,                                                                  
@PKID int = null                                                                  
AS    
BEGIN  
  IF @Action = 'Hotel_WinYatraBooking'                                                                          
   BEGIN          
     SELECT
--TOP 1000  
TOP 1 HB.pkid,
      HB.bookingreference,
      HB.hotel_erpresponceid,
      HB.agentcommission,
      MU.fullname + '-' + MU.username                           AS 'UserName',
      BW.branchid,
      BW.subled,
      HB.cityname,
      HB.hotel_erppushstatus,
      HB.agentid,
      HB.riyaagentid,
      AL.usertypeid,
    convert( varchar(10),  HB.inserteddate,120)  'inserteddate',
      BW.subled,
      HB.riyapnr,
      Isnull(BW.ledgers, (SELECT ledgers
                          FROM   tblwinyatrahotelmapping
                          WHERE  fkstateid = B2BR.stateid
                                 AND supplier = 'Agoda India')) AS Icast,
      AL.usertypeid,
      HB.hotel_erpresponceid,
      HB.suppliername,
      HB.leadertitle,
      HB.leaderfirstname,
      HB.leaderlastname,
     convert( varchar(10), HB.checkindate,120) as 'checkindate',
     convert( varchar(10),HB.checkoutdate,120) as 'checkoutdate',
      HB.totalrooms,
      HB.meal,
      HB.hoteltds,
      HB.specialremark,
      HB.totalchildren,
      HB.totaladults,
      Cast(HB.totaladults AS INT)
      + Cast(HB.totalchildren AS INT)                           AS TotalPax,
      HB.finalroe,
      HB.hoteltotalgross,
      B2BC.suppliercommission,
      B2BR.customercode,
      B2BR.icast                                                AS obcust,
      B2BR.agencyname,
      HB.providerconfirmationnumber,
      HB.agentrefno,
      HB.obtcno,
      HB.displaydiscountrate,
      HB.servicecharge,
      HB.currencycode,
      HB.suppliercurrencycode,
      HB.supplierrate,
      HB.roevalue,
      Replace(HB.hotelname, '&', 'and')                         AS 'HotelName',
      HB.supplierreferenceno,
      B2BC.tds,
      HB.hotelconfnumber,
      HB.sinrcommissionamount,
      ( B2BC.earningamount + B2BC.tdsdeductedamount )           AS agentShare,
      HB.cancellationdeadline,
      HB.winyatrainvoice,
      HB.winyatraerror,
      CASE B2BR.entitytype
        WHEN 'Agent' THEN 'A'
        WHEN 'APIOUT' THEN 'A'
        WHEN 'Intercompany' THEN 'I'
        WHEN 'Internal' THEN 'NA'
      END                                                       AS 'AgtType',
      CASE Upper(Isnull(HB.destinationcountrycode, HB.hotelbookcountrycode))
        WHEN 'INDIA' THEN '510010'
        WHEN 'IN' THEN '510010'
        ELSE '510020'
      END                                                       'ObCrCode'
FROM   hotel_bookmaster HB
       LEFT JOIN agentlogin AL
              ON AL.userid = HB.riyaagentid
       --LEFT JOIN Hotel_Pax_master PM on HB.pkId = PM.book_fk_id                                                                  
       LEFT JOIN b2bregistration B2BR
              ON HB.riyaagentid = B2BR.fkuserid
       LEFT JOIN tblwinyatrahotelmapping BW
              ON B2BR.stateid = BW.fkstateid
                 AND HB.supplierusername = BW.[rhsupplierid]
       INNER JOIN(SELECT fkhotelbookingid,
                         Max(id) AS max_id,
                         fkstatusid
                  FROM   hotel_status_history AS cc
                  WHERE  cc.fkstatusid = 4
                  GROUP  BY fkhotelbookingid,
                            fkstatusid) AS HSHVouchred
               ON HSHVouchred.fkhotelbookingid = HB.pkid
       LEFT JOIN muser MU
              ON MU.id = HB.mainagentid
       LEFT JOIN b2bhotel_commission B2BC
              ON B2BC.fk_bookid = HB.pkid                                                    
   WHERE                                                                  
     /*wIN YATRA DATA TOB PUSEHED IRESPECTIVE OF PAYMENT MODE,                                
   BOOKING STATUS SHOULD BE VOUCHERED,                                
   USER TYPE SHOULD BE hOLIDAY.                                
    IT WILL TRIGGERER REAL TIME.                                
   */                                
    HSHVouchred.FkStatusId=4                                  
 and (          
 (AL.userTypeID = 2 and B2BR.Icast in (select HotelIcust from tblInterBranchWinyatra))           
 or           
 AL.userTypeID IN(4))                                                                  
 AND DATEDIFF(MINUTE,CAST( HB.inserteddate AS datetime),GETDATE())>5                                
      AND CAST( HB.inserteddate  AS DATE )>= CAST('2025-03-25' AS DATE)                                
 and (isnull(HB.winyatraInvoice ,' ')=' ' )      
 AND isnull(HB.winyatraError,'') !='Invalid PNR No. Or PNR No. already converted into Invoice !!!'      
   and  HB.BookingReference in ('TNHAPI00113391')          
   --('TNH00271205')          
   --('TNHAPI00074774','TNHAPI00074775')          
   --('TNH00269961','TNH00269963')              
   --('TNH00269711')--('TNH00269504','TNH00269514')    --TNH00264660                                                              
                                                        
                               
   order by HB.inserteddate desc                                                                    
   END                                                                    
   
END  