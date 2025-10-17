CREATE procedure GetTJQCorporateRecords                    
@IsBookMasterInserted int = 0,      
@OfficeID varchar(250) = ''      
as                    
begin                    
                    
Select top 1 ID,GDSPNR,ICUST,OfficeID,AirLineNumber,TicketNumber,IssueDate From PNRRetrivalFromAudit       
where PNRRetrivalFromAudit.OfficeID IN  ( select Data from sample_split(@OfficeID ,','))      
and IsBookMasterInserted = @IsBookMasterInserted and IsBookMasterInserted = 20 order by Id desc                   
End