CREATE PROCEDURE [SS].[SightSeeingGetManageBookingDetails_backupRavi27102023]                                                                                            
	@AgentId INT                                                                                                                                                                                                    
AS                                                                                                            
BEGIN     

	SELECT SBM.BookingId, SBM.BookingStatus, SBM.CityName, 
		SBM.TripStartDate, SBM.TripEndDate, BR.AddrMobileNo AS AgentMobile, SBM.BookingRate,
		SBM.BookingRefId, SBM.PassengerEmail, SBM.PassengerPhone, BR.AgencyName,
		SPD.Name AS PassengerName, SPD.Surname AS PassengerSurName, SBM.creationDate,
		SBM.PaymentMode, SBM.AgentID, SBM.MainAgentID, ISNULL(SBM.SubMainAgntId, 0) AS SubMainAgntId,

		-- BookedActivities 
		SBA.ActivityStatus, SBA.ActivityName
	
	FROM SS.SS_BookingMaster SBM WITH(NOLOCK)
		OUTER APPLY (SELECT top 1 SBA.ActivityStatus, SBA.ActivityName
			FROM SS.SS_BookedActivities SBA WITH(NOLOCK) WHERE SBM.BookingId= SBA.BookingId) SBA
		OUTER APPLY (SELECT top 1 SPD.Name, SPD.Surname
			FROM SS.SS_PaxDetails SPD WITH(NOLOCK) WHERE SBM.BookingId = SPD.BookingId) SPD
		LEFT JOIN AgentLogin AL WITH(NOLOCK) ON SBM.AgentID = AL.UserID   
		LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON SBM.AgentID = BR.FKUserID                                                                                                

	WHERE SBM.AgentID = @AgentId
	ORDER BY SBM.BookingId DESC
END
