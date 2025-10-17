--exec [TR].[TR_TransferGetManageBookingDetails]  51379 ,"", "","","","","","","","","","","","","","","","69"                                                         
CREATE PROCEDURE [TR].[TR_TransferGetManageBookingDetails]                                                                                                                   
 @AgentId INT,                                          
 @MainAgentId varchar(max) = '' ,                                                                                                       
 @BookingFromDate varchar(50) ='', -- mm dd yyyy                                                                                                          
 @BookingTodate varchar(50) ='',                                          
 @CheckInFromDate datetime ='',                                                                                                  
 @CheckInTodate datetime ='',                                          
 @DeadLineFromDate datetime ='',                                                                                                       
 @DeadLineTodate datetime ='',                                           
 @BookingStatus varchar(200)='',                                                                                                  
 @BookingNo varchar(50)='' ,                                          
 @StateId int=0,                                                                        
 @RiyaAgentId varchar (50) = '',                                                                     
 @SubMainAgentId varchar (50) = '',                                                                    
 @PassengerPhone varchar (50) = '' ,                                                        
 @PassengerEmail varchar (50)='',                                                        
 @PassengerName varchar (50)='' ,                                                                                  
 @cityName varchar (50) = '' ,                                    
 @RefName varchar (50)=''                                    
AS                                                                                                                                                      
BEGIN                                               
                                          
		 if @BookingTodate in ('',NULL)                                                                                                  
		set @BookingTodate = DATEADD(DAY,1,@BookingFromDate)                                                                                                  
		else set @BookingTodate = DATEADD(DAY,1,@BookingTodate)                                                                                                                                                         
                                                             
		if @DeadLineTodate in ('',NULL)                                                                                                  
		set @DeadLineTodate = DATEADD(DAY,1,@DeadLineFromDate)                                                                                                  
		else set @DeadLineTodate = DATEADD(DAY,1,@DeadLineTodate)                                            
                                          
		if @CheckInTodate in ('',NULL)                                                                                                  
		set @CheckInTodate = DATEADD(DAY,1,@CheckInFromDate)                                                                                                  
		else set @CheckInTodate = DATEADD(DAY,1,@CheckInTodate)                                          
                                          
		if @BookingStatus in ('0',NULL)                                                                                                  
		set @BookingStatus = ''                                              
		IF (@BookingNo <>'0')
			BEGIN
				SET @BookingFromDate=''
				SET @BookingTodate=''
			END
          print (@BookingFromDate)                  
		  print (@BookingTodate)  
	IF(@MainAgentId != '0')                        
		BEGIN                                          
			set @StateId=(SELECT distinct StateID from B2BRegistration where FKUserID=@AgentId)                                                                                 
			SELECT  
				SBM.creationDate, SSH.FkStatusId, SPD.Name, SBM.BookingId, SBM.BookingStatus, SBM.PickupLocation AS PickupLocation, SBM.DropOffLocation AS  DropOffLocation,           
				CONCAT(SBM.PickupLocation, ' - ', SBM.DropOffLocation) AS CityName,          
				SBM.TripStartDate, SBM.TripEndDate, BR.AddrMobileNo AS AgentMobile,                                          
				SBM.BookingRefId,  SBM.ProviderContactNumber, BR.AgencyName,                 
				SPD.Name AS PassengerName, SPD.Surname AS PassengerSurName,                   
				SBM.AgentID, SBM.MainAgentID, ISNULL(SBM.SubMainAgntId, 0) AS SubMainAgntId,SBM.SubMainAgntId AS SubUserId,                                       
				SBM.SupplierRate,                                      
				SBM.providerName as RefName,                                
				SBM.CancellationDeadline as CancelDate,                                
				SBM.creationDate as InsertDate,            
				SBM.AmountBeforePgCommission as AmountBeforePgCommission,            
				SPD.Contact AS PassengerPhone,                    
				SPD.Email AS PassengerEmail,                    
				SBA.CarName As ActivityName,                    
				CASE WHEN  HU1.FullName IS NOT NULL THEN                                              
				BR.AgencyName + ' '  + ' - ' + isnull(HU.FullName,'') + ' '  + ' ( ' + isnull(HU1.FullName,'')  + ' ) '                                                          
				ELSE                                 
				BR.AgencyName + ' ' + ' - ' + isnull(HU.FullName,'') END  as 'AgentName' ,                                
                                          
				-- BookedActivities                                           
				SBA.BookingStatus, SBA.CarName ,                                      
				CASE                                      
				WHEN SBM.PaymentMode = 4 THEN 'Self Balance'                                      
				WHEN SBM.PaymentMode = 2 THEN 'Credit Limit'                                      
				WHEN SBM.PaymentMode = 3 THEN 'Make Payment'                                      
				ELSE 'HOLD'                                      
				END AS PaymentMode                                      
                                           
			FROM 
				TR.TR_BookingMaster SBM WITH(NOLOCK)                                          
				JOIN [TR].[TR_Status_History] SSH WITH(NOLOCK) ON SBM.BookingId = SSH.BookingId                                          
				OUTER APPLY (SELECT top 1 SBA.BookingStatus, SBA.CarName                                          
				FROM TR.TR_BookedCars SBA WITH(NOLOCK) WHERE SBM.BookingId= SBA.BookingId) SBA                                          
				LEFT JOIN  TR.TR_PaxDetails SPD WITH(NOLOCK) ON SBM.BookingId = SPD.BookingId                                           
				LEFT JOIN muser HU WITH(NOLOCK) ON HU.ID = SBM.MainAgentID                                          
				LEFT JOIN muser HU1 WITH(NOLOCK) ON HU1.ID = SBM.SubMainAgntId                                          
				LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON SBM.AgentID = BR.FKUserID                                  
				left join AgentLogin BR1 on SBM.SubMainAgntId = BR1.UserId                  
                                     
			WHERE --SBM.AgentID = @AgentId                                          
				SSH.IsActive = 1                                  
				AND SBM.MainAgentID IS NOT NULL                                          
				and((IsNumeric(@AgentId)>0 AND SBM.AgentID=@AgentId) or SBM.MainAgentID=@MainAgentId)                                          
				AND ((Convert(date,SBM.creationDate) >= Convert(date,@BookingFromDate) and Convert(date,SBM.creationDate) < @BookingTodate) or @BookingFromDate='')                                                                                                  
				AND ((Convert(date,SBM.TripStartDate) >= Convert(date,@CheckInFromDate) and Convert(date,SBM.TripEndDate) < @CheckInTodate ) or @CheckInFromDate='')                                                          
				AND (SSH.FkStatusId IN(select cAst(Item as int) FROM dbo.SplitString(@BookingStatus,',') )   or @BookingStatus = '' )                                                                                                     
				AND (SBM.BookingRefId=@BookingNo or @BookingNo = '')                                
                                                
			ORDER BY SBM.BookingId DESC                                           
			END                                          
ELSE IF(@MainAgentId='0' or @MainAgentId='')                                           
BEGIN                                          
			SELECT  
				SBM.creationDate,  SBM.AmountBeforePgCommission as AmountBeforePgCommission,   SSH.FkStatusId, SPD.Name, SBM.BookingId, SBM.BookingStatus, SBM.PickupLocation,CONCAT(SBM.PickupLocation, ' - ', SBM.DropOffLocation) AS CityName,                                            
				SBM.TripStartDate, SBM.TripEndDate, BR.AddrMobileNo AS AgentMobile,                                          
				SBM.BookingRefId,  SBM.ProviderContactNumber, BR.AgencyName,                                          
				SPD.Name AS PassengerName, SPD.Surname AS PassengerSurName,                                          
				SBM.AgentID, SBM.MainAgentID, ISNULL(SBM.SubMainAgntId, 0) AS SubMainAgntId,SBM.SubMainAgntId AS SubUserId,                                       
				SBM.SupplierRate,                                      
				SBM.providerName as RefName,                                
				SBM.CancellationDeadline as CancelDate,                                
				SBM.creationDate as InsertDate,                     
				SPD.Contact AS PassengerPhone,                    
				SPD.Email AS PassengerEmail,                    
				SBA.CarName As ActivityName,                    
				CASE WHEN  HU1.FullName IS NOT NULL THEN                                              
				BR.AgencyName + ' '  + ' - ' + isnull(HU.FullName,'') + ' '  + ' ( ' + isnull(HU1.FullName,'')  + ' ) '                                                          
				ELSE                                 
				BR.AgencyName + ' ' + ' - ' + isnull(HU.FullName,'') END  as 'AgentName' ,                                
                                          
				-- BookedActivities                                           
				SBA.BookingStatus, SBA.CarName ,                                      
				CASE                                      
				WHEN SBM.PaymentMode = 4 THEN 'Self Balance'                                      
				WHEN SBM.PaymentMode = 2 THEN 'Credit Limit'                                      
				WHEN SBM.PaymentMode = 3 THEN 'Make Payment'                                      
				ELSE 'HOLD'                                      
				END AS PaymentMode                                      
                                           
			FROM 
				TR.TR_BookingMaster SBM WITH(NOLOCK)                                          
				JOIN [TR].[TR_Status_History] SSH WITH(NOLOCK) ON SBM.BookingId = SSH.BookingId                                          
				OUTER APPLY (SELECT top 1 SBA.BookingStatus, SBA.CarName                                          
				FROM TR.TR_BookedCars SBA WITH(NOLOCK) WHERE SBM.BookingId= SBA.BookingId) SBA                                          
				LEFT JOIN  TR.TR_PaxDetails SPD WITH(NOLOCK) ON SBM.BookingId = SPD.BookingId                                           
				LEFT JOIN muser HU WITH(NOLOCK) ON HU.ID = SBM.MainAgentID                                          
				LEFT JOIN muser HU1 WITH(NOLOCK) ON HU1.ID = SBM.SubMainAgntId                                          
				LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON SBM.AgentID = BR.FKUserID                                  
				left join AgentLogin BR1 on SBM.SubMainAgntId = BR1.UserId                  
                     
                                          
			WHERE 
				SBM.AgentID = @AgentId    
				AND SSH.IsActive = 1                                              
				AND ((Convert(date,SBM.creationDate) >= Convert(date,@BookingFromDate) and Convert(date,SBM.creationDate) < @BookingTodate) or @BookingFromDate='')                                    
				AND ((Convert(date,SBM.TripStartDate) >= Convert(date,@CheckInFromDate) and Convert(date,SBM.TripEndDate) < @CheckInTodate ) or @CheckInFromDate='')                                                
				AND (SSH.FkStatusId IN(select cAst(Item as int) FROM dbo.SplitString(@BookingStatus,',') )   or @BookingStatus = '' )                                                                                                     
				AND (SBM.BookingRefId=@BookingNo or @BookingNo = '')                         
                                              
				ORDER BY SBM.BookingId DESC                      
                    
END                                          
                                          
END 