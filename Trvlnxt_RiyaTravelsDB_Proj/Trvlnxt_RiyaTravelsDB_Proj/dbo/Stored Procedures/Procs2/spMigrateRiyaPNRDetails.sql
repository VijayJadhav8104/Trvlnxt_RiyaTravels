CREATE proc spMigrateRiyaPNRDetails    
    
@RIYAPNR varchar(20)    
    
As    
Begin    
    
if exists(select * from tblBookMaster where riyaPNR=@RIYAPNR and (isbooked=0 OR isbooked IS NULL))    
begin    
    
insert into tblPassengerBookDetailsHistory ( [pid],[fkBookMaster],[paxType],[paxFName],[paxLName],[passportNum],[passportIssueCountry],[passexp],[inserteddate],[status],[title]    
      ,[dateOfBirth],[nationality],[gender],[ticketNum],[Isrescheduled],[Iscancelled],[YQ],[TDSamount],[serviceCharge],[managementfees]    
      ,[airlineCancellationPanelty],[riyaCancellationCharges],[RemainingRefund],[RefundAmount],[IsRefunded],[RefundedDate],[reScheduleCharge]    
      ,[airPNR],[cancellationRemark],[fflyer],[baggage],[totalFare],[basicFare],[totalTax],[isReturn],[Discount],[FlatDiscount],[GovtTax]    
      ,[CancellationCharge],[Panelty],[YRTax],[INTax],[JNTax],[OCTax],[ExtraTax],[DiscriptionTax],[isProcessRefund],[CancelledDate]    
      ,[CommissionType],[ServiceChargeType],[FlatDiscountType],[CancellationChargeType],[IATACommission],[PLBCommission],[GovtTaxPercent]    
      ,[IATAPercent],[PLBPercent],[IsIATAOnBasic],[IsPLBOnBasic],[CancelClosed],[Markup],[ERPkey],[FailedFlag],[PassIssue])    
    
select [pid],[fkBookMaster],[paxType],[paxFName],[paxLName],[passportNum],[passportIssueCountry],[passexp],[inserteddate],[status],[title]    
      ,[dateOfBirth],[nationality],[gender],[ticketNum],[Isrescheduled],[Iscancelled],[YQ],[TDSamount],[serviceCharge],[managementfees]    
      ,[airlineCancellationPanelty],[riyaCancellationCharges],[RemainingRefund],[RefundAmount],[IsRefunded],[RefundedDate],[reScheduleCharge]    
      ,[airPNR],[cancellationRemark],[fflyer],[baggage],[totalFare],[basicFare],[totalTax],[isReturn],[Discount],[FlatDiscount],[GovtTax]    
      ,[CancellationCharge],[Panelty],[YRTax],[INTax],[JNTax],[OCTax],[ExtraTax],[DiscriptionTax],[isProcessRefund],[CancelledDate]    
      ,[CommissionType],[ServiceChargeType],[FlatDiscountType],[CancellationChargeType],[IATACommission],[PLBCommission],[GovtTaxPercent]    
      ,[IATAPercent],[PLBPercent],[IsIATAOnBasic],[IsPLBOnBasic],[CancelClosed],[Markup],[ERPkey],[FailedFlag],[PassIssue]    
  FROM tblPassengerBookDetails where fkBookMaster in (select pkId from tblBookMaster where riyaPNR=@RIYAPNR)    
    
  delete from tblPassengerBookDetails where fkBookMaster in (select pkId from tblBookMaster where riyaPNR=@RIYAPNR and (isbooked=0 OR isbooked IS NULL ) )    
    
INSERT INTO tblbookmasterhistory     
            ([pkid],[orderid],[frmsector],[tosector],[fromairport],[toairport],[airname],[operatingcarrier],[aircode],[equipment],     
             [flightno],[isreturnjourney],[depdate],[arrivaldate],[riyapnr],[taxdesc],[totalfare],[totaltax],[basicfare],[depttime],     
             [canceleddate],[arrivaltime],[gdspnr],[isbooked],[inserteddate],[ip],[totaldiscount],[flatdiscount],[cancellationcharge],     
             [servicecharge],[promocode],[govttax],[mobileno],[emailid],[returnflag],[travclass],[fromterminal],[toterminal],[totaltime],     
             [counterclosetime],[remarks],[yrtax],[intax],[jntax],[octax],[extratax],[yqtax],[userid],[commissiontype],[servicechargetype],     
             [flatdiscounttype],[cancellationchargetype],[faresellkey],[journeysellkey],[iatacommission],[plbcommission],[iatapercent],     
             [plbpercent],[vendorcommissionpercent],[vendorcommissiontext],[isiataonbasic],[isplbonbasic],[govttaxpercent],[uniqueid],    
    [bookingsource],[sessionid],[loginemailid],[registrationnumber],[companyname],[caddress],[cstate],[ccontactno],[cemailid],    
    [promodiscount],[ticketissuanceerror],[officeid],[country],[roe],[agentid],[agentaction],[agentdealdiscount],[ticketissue],     
             [suppliercode],[vendorcode],[totalmarkup],[bookingtype],[displaytype],[calculationtype],[agentmarkup],[ticketmail],[journey],     
             [inserteddate_old],[trackid],[vendor_no],[iata],[faretype])     
SELECT [pkid],[orderid],[frmsector],[tosector],[fromairport],[toairport],[airname],[operatingcarrier],[aircode],[equipment],     
        [flightno],[isreturnjourney],[depdate],[arrivaldate],[riyapnr],[taxdesc],[totalfare],[totaltax],[basicfare],[depttime],     
             [canceleddate],[arrivaltime],[gdspnr],[isbooked],[inserteddate],[ip],[totaldiscount],[flatdiscount],[cancellationcharge],     
             [servicecharge],[promocode],[govttax],[mobileno],[emailid],[returnflag],[travclass],[fromterminal],[toterminal],[totaltime],     
             [counterclosetime],[remarks],[yrtax],[intax],[jntax],[octax],[extratax],[yqtax],[userid],[commissiontype],[servicechargetype],     
             [flatdiscounttype],[cancellationchargetype],[faresellkey],[journeysellkey],[iatacommission],[plbcommission],[iatapercent],     
             [plbpercent],[vendorcommissionpercent],[vendorcommissiontext],[isiataonbasic],[isplbonbasic],[govttaxpercent],[uniqueid],    
    [bookingsource],[sessionid],[loginemailid],[registrationnumber],[companyname],[caddress],[cstate],[ccontactno],[cemailid],    
    [promodiscount],[ticketissuanceerror],[officeid],[country],[roe],[agentid],[agentaction],[agentdealdiscount],[ticketissue],     
             [suppliercode],[vendorcode],[totalmarkup],[bookingtype],[displaytype],[calculationtype],[agentmarkup],[ticketmail],[journey],     
             [inserteddate_old],[trackid],[vendor_no],[iata],[faretype]    
FROM   tblbookmaster where riyaPNR=@RIYAPNR    
    
delete from tblbookmaster where riyaPNR=@RIYAPNR and (isbooked=0 OR isbooked IS NULL  )    
    
--SET IDENTITY_INSERT tblbookmasterhistory on    
end    
END