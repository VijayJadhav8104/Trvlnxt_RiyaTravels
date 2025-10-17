                                            
CREATE procedure APISectors                                            
@Travelfrom varchar(20) ,                                           
@Travelto varchar(20)                                            
                                            
As                                             
begin                                            
SELECT STUFF                                              
            (                                              
                (                                              
                    SELECT distinct ',' + P.Carrier FROM tblAirlineSectors P                                              
                   where fromSector=@Travelfrom and toSector=@Travelto and IsActive=1                                        
                    FOR XML PATH('')                                              
                )                                             
            ,1,1,'') as Carrier                                
                                
select 'Amadeus,AmadeusNDC,SalamAir,FlyEgypt,FitsAir,OneAirArabia' as cachingvendors                                
                              
 --,Sabre,SabreNDC,GFNDC,EKNDC,Travelfusion,TravelfusionNDC,FlyDubai,AerTicket,Jazeera,AIExpress,AkasaAir,SpiceJet                    
                          
              
 SELECT  p.Days FROM tblAirlineSectors P                                              
              where fromSector= @Travelfrom and toSector= @Travelto and Carrier = '9I' and IsActive=1                
                   
end 