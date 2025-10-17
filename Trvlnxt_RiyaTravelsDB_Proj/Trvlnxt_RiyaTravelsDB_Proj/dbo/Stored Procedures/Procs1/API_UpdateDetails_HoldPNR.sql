                        
CREATE procedure [dbo].[API_UpdateDetails_HoldPNR] -- API_HoldPNRDetails 'TNA8MO4FA9'                        
@totalFare varchar(50) = ''            
,@basicFare varchar(50) = ''          
,@totalTax varchar(50) = ''          
,@YQTax varchar(50) = ''          
,@YMTax varchar(50) = ''          
,@YRTax varchar(50) = ''          
        
,@JNTax varchar(50) = ''         
,@OCTax varchar(50) = ''         
,@OBTax varchar(50) = ''         
,@WOTax varchar(50) = ''         
,@RFTax varchar(50) = ''         
,@ExtraTax varchar(50) = ''         
,@taxDesc varchar(50) = ''        
,@PaxId varchar(50) = ''      
,@fkBookMaster varchar(50) = ''  
,@K7Tax varchar(50) = ''      
                        
as begin                        
                        
if(@fkBookMaster != null and @fkBookMaster != '')        
 begin         
  update tblBookMaster         
  set          
  totalFare = @totalFare        
  ,basicFare = @basicFare        
  ,totalTax = @totalTax        
  ,YQTax = @YQTax        
  ,YMTax = @YMTax        
  ,YRTax = @YRTax        
  ,JNTax = @JNTax        
  ,OCTax = @OCTax        
  ,OBTax = @OBTax        
  ,WOTax = @WOTax        
  ,RFTax = @RFTax  
  ,K7Tax = @K7Tax        
  ,ExtraTax = @ExtraTax        
  ,taxDesc = @taxDesc        
  where pkId = @fkBookMaster and totalFare > 0              
 end          
else         
 begin        
  update tblPassengerBookDetails         
  set          
  totalFare = @totalFare        
  ,basicFare = @basicFare        
  ,totalTax = @totalTax        
  ,YQ = @YQTax        
  ,YMTax = @YMTax        
  ,YRTax = @YRTax        
  ,JNTax = @JNTax        
  ,OCTax = @OCTax        
  ,OBTax = @OBTax        
  ,WOTax = @WOTax        
  ,RFTax = @RFTax   
  ,K7Tax = @K7Tax        
  ,ExtraTax = @ExtraTax        
  ,DiscriptionTax = @taxDesc        
  where pid = @PaxId and totalFare > 0        
 end        
end