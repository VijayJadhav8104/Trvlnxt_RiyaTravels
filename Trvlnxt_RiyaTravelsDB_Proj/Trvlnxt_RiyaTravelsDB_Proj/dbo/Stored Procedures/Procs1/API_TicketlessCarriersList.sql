CREATE procedure [dbo].[API_TicketlessCarriersList]                        
             
as                        
begin  

select AirlineCode,AirlineName From TicketlessCarriers

end