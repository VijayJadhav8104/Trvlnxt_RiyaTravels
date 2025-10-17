create VIEW  manasvee1 AS
(select b.inserteddate, b.riyaPNR, b.orderId, totalFare,TotalDiscount, floor(round((totalFare-(TotalDiscount +FlatDiscount) + TotalMarkup),0) * b.ROE) as TotalAmount, floor(mer_amount / b.roe) as merchantamt,
floor(mer_amount / b.roe)- round((totalFare-(TotalDiscount+FlatDiscount) + TotalMarkup),0) as diff from tblBookMaster b
inner join Paymentmaster p on p.order_id=b.orderId 
where IsBooked=1 and b.isReturnJourney=0  
);