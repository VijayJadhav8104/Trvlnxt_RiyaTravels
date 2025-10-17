
create VIEW  manasvee2 AS(
select b.inserteddate, b.riyaPNR, b.orderId, b.totalFare,( case b.TotalDiscount when 0 then b1.TotalDiscount else b.TotalDiscount end ) as TotalDiscount, 
floor(round(((b.totalFare + b1.totalFare)-((case b.TotalDiscount when 0 then b1.TotalDiscount else b.TotalDiscount end)) + b.TotalMarkup),0) * b.ROE) as TotalAmount, 
floor(mer_amount / b.roe) as merchantamt,
floor(mer_amount / b.roe)- isnull(round(((b.totalFare+b1.totalFare)-((case b.TotalDiscount when 0 then b1.TotalDiscount else b.TotalDiscount  end)) + b.TotalMarkup),0),0) as diff from tblBookMaster b
inner join Paymentmaster p on p.order_id=b.orderId and b.returnFlag=0
inner join tblBookMaster b1 on b1.orderId=b.orderId and b1.returnFlag=1
where b.IsBooked=1 and b.isReturnJourney=1 and b.AgentID='b2c');