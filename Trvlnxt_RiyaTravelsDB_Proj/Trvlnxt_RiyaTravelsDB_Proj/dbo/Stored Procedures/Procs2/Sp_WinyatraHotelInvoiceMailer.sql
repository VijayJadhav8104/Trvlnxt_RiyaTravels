CREATE procedure [dbo].[Sp_WinyatraHotelInvoiceMailer]  
As  
Begin  
select   
PB.pkId,pb.BookingReference,  
pb.OBTCNo,pb.winyatraInvoice,  
WD.*  
,U.EmployeeNo,U.FullName from WinYatraDataLog WD   
                        LEFT Join Hotel_BookMaster PB WITH (NOLOCK) on PB.pkId = WD.fk_bookmasterId   
                        --LEFT Join tblBookMaster BM WITH (NOLOCK) on PB.fkBookMaster = BM.pkId   
                        LEFT JOIN mUser U WITH (NOLOCK) on PB.MainAgentID = U.ID   
                        where  
      PB.pkId is not null and  
  
      cast( WD.CreatedOn  as date) =Cast(GETDATE()-1 as date)  
      --between    
      -- Cast('20241210' as datetime)    
      --and Cast(GETDATE() as datetime)  
      order by Cast( pb.inserteddate as datetime) desc  
  
      END  