CREATE proc [dbo].[GetAgentNamesfordropdown]-- 'CUST00511','IN,US,CA,AE'   --[GetAgentNames] '','CUST00511','IN,US,CA,AE'                                                                                           ','us'
@Icust varchar(200),
@Country varchar(50)=null
AS
BEGIN
	if (@Country ='')
		begin
 	 	 	 if(@Icust!='')
	  		   BEGIN
	   				SELECT A.userid as PKID,AgencyName,Icast,
					(case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END) as 'DisplayName',
					a.UserName FROM B2BRegistration B
					INNER JOIN AgentLogin A ON A.UserID=B.FKUserID
					WHERE	 A.AgentApproved=1 and UserTypeID is not null
				END
				else
				BEGIN
						SELECT top 100 A.userid as PKID ,AgencyName,Icast,
						(case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END) as 'DisplayName',
						a.UserName,A.UserTypeID FROM B2BRegistration B
						INNER JOIN AgentLogin A ON A.UserID=B.FKUserID
						WHERE A.AgentApproved=1  and UserTypeID is not null
						order by a.InsertedDate desc
				END
		end
	else
		begin
	  if(@Icust!='')
	
  			 BEGIN
	   				SELECT A.userid as PKID,AgencyName,Icast,
					(case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END) as 'DisplayName',
					a.UserName,A.UserTypeID FROM B2BRegistration B
					INNER JOIN AgentLogin A ON A.UserID=B.FKUserID
					WHERE
					 A.BookingCountry in  ( select DATA from sample_split(@Country,',') )  AND A.AgentApproved=1 and UserTypeID is not null 
			END
			else
			BEGIN
					SELECT top 100 A.userid as PKID ,AgencyName,Icast,
					(case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END) as 'DisplayName',
					a.UserName,A.UserTypeID FROM B2BRegistration B
					INNER JOIN AgentLogin A ON A.UserID=B.FKUserID
					WHERE	
 				   A.BookingCountry in  ( select DATA from sample_split(@Country,',') )  AND A.AgentApproved=1
                    AND B.Status=1 and UserTypeID is not null  order by a.InsertedDate desc 
				
			END
end
	END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAgentNamesfordropdown] TO [rt_read]
    AS [dbo];

