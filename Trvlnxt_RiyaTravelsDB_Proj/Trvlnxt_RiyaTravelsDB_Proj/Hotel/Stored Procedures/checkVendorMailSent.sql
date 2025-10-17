          
CREATE procedure [Hotel].[checkVendorMailSent]          
          
@Type varchar(20)=null,          
@Date varchar(20)= ''          
           
as           
begin          
          
IF @Date IS NULL     BEGIN         SET @Date = CONVERT(varchar(10), GETDATE(), 23) -- 23 format is 'yyyy-mm-dd'           
END          
          
if(@Type = 'Check')          
          
begin          
select  MailSent,CurrentDate from hotel.VendorReportMailerCheck where convert(varchar(10),CurrentDate,23)=CONVERT(varchar(10), GETDATE(), 23)      
--@Date   
end          
          
else if( @Type='Insert')          
          
begin          
      
--select * from hotel.VendorReportMailerCheck      
insert into hotel.VendorReportMailerCheck(CurrentDate,MailSent)          
Values (@Date,1)          
end          
END 