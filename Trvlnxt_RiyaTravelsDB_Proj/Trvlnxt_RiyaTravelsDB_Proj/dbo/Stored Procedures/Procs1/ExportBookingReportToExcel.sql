CREATE PROCEDURE ExportBookingReportToExcel
AS
BEGIN
    DECLARE @html NVARCHAR(MAX);

    SET @html = '
    <html>
    <head>
    <style>
    th {
        background-color: blue;
        color: red;
        border: 1px solid black;
        padding: 8px;
        text-align: left;
    }

    td {
        border: 1px solid black;
        padding: 8px;
        text-align: left;
    }
    </style>
    </head>
    <body>
    <table>
    <tr>
    <th>UserType</th>
    <th>Booking Id</th>
    <th>Agency User</th>
    <th>Agenct ID</th>
    <th>User Name</th>
    <th>Leader Guest Name</th>
    <th>Booking Date</th>
    <th>CheckIn Date</th>
    <th>Checkout Date</th>
    <th>Cancellation Deadline</th>
    <th>Booking Status</th>
    <th>Mode Of Payment</th>
    <th>Booking Currency</th>
    <th>Booking Amount</th>
    <th>Supplier Ref. No</th>
    <th>Supplier</th>
    <th>City</th>
    <th>Country</th>
    <th>Hotel Name</th>
    <th>No. of Passengers</th>
    <th>No. of Nights</th>
    <th>No. of Rooms</th>
    <th>Total Room Nights</th>
    <th>Hotel Confirmation</th>
    </tr>';

    SELECT @html = @html +
                '<tr>' +
                '<td>' + Mc.Value + '</td>' +
                '<td>' + HB.BookingReference + '</td>' +
                '<td>' + BR.AgencyName + '</td>' +
                '<td>' + BR.Icast + '</td>' +
                '<td>' + ISNULL(mu.FullName, '') + '</td>' +
                '<td>' + HB.LeaderTitle + ' ' + HB.LeaderFirstName + ' ' + HB.LeaderLastName + '</td>' +
                '<td>' + CONVERT(VARCHAR, HB.inserteddate, 0) + '</td>' +
                '<td>' + FORMAT(HB.CheckInDate, 'MMM dd yyyy') + ' ' + HB.CheckInTime + '</td>' +
                '<td>' + FORMAT(HB.CheckOutDate, 'MMM dd yyyy') + ' ' + HB.CheckOutTime + '</td>' +
                '<td>' + CONVERT(VARCHAR, HB.CancellationDeadLine, 0) + '</td>' +
                '<td>' + HB.CurrentStatus + '</td>' +
                '<td>' + CASE
                            WHEN HB.B2BPaymentMode = 1 THEN 'Hold'
                            WHEN HB.B2BPaymentMode = 2 THEN 'Credit Limit'
                            WHEN HB.B2BPaymentMode = 3 THEN 'Make Payment'
                            WHEN HB.B2BPaymentMode = 4 THEN 'Self Balalnce'
                            WHEN HB.B2BPaymentMode = 5 THEN 'Pay@Hotel'
                            ELSE 'NA'
                        END + '</td>' +
                '<td>' + HB.CurrencyCode + '</td>' +
                '<td>' + HB.CurrencyCode + ' ' + HB.DisplayDiscountRate + '</td>' +
                '<td>' + HB.SupplierReferenceNo + '</td>' +
                '<td>' + HB.SupplierName + '</td>' +
                '<td>' + REPLACE(HB.cityName, ',', '_') + '</td>' +
                '<td>' + REPLACE(HB.CountryName, ',', '_') + '</td>' +
                '<td>' + REPLACE(HB.HotelName, ',', '_') + '</td>' +
                '<td>' + TotalAdults + '|' + TotalChildren + '</td>' +
                '<td>' + SelectedNights + '</td>' +
                '<td>' + TotalRooms + '</td>' +
                '<td>' + SelectedNights + '</td>' +
                '<td>' + HotelConfNumber + '</td>' +
                '</tr>'
    FROM Hotel_BookMaster HB
    LEFT JOIN agentLogin AL ON HB.RiyaAgentID = AL.UserID
    LEFT JOIN B2BRegistration BR ON BR.FKUserID = AL.UserID
    LEFT JOIN mCommon Mc ON Mc.ID = AL.UsertypeId
    LEFT JOIN mUser MU ON HB.MainAgentID = MU.ID
    WHERE Mc.ID = 5
    AND CAST(HB.inserteddate AS DATE) BETWEEN DATEADD(DAY, -1, CAST(GETDATE() AS DATE)) AND DATEADD(DAY, -1, CAST(GETDATE() AS DATE));

    SET @html = @html + '</table></body></html>';

    PRINT @html;

	-- Send the e-mail with the query results in the HTML body
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'dba_Automations',
    @recipients = 'dba@riya.travel',
    @subject = 'TrvlNxt Daily RBT Booking Report',
    @body = @html,
    @body_format = 'HTML'
;
END
