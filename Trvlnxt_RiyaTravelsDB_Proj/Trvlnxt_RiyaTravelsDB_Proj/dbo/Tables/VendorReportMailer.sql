CREATE TABLE [dbo].[VendorReportMailer] (
    [Vendor_Name]                    NVARCHAR (300) NULL,
    [Vendor_Billing_Currency]        VARCHAR (10)   NULL,
    [Total_Booking_foriegn_Currency] VARCHAR (52)   NOT NULL,
    [Total_Booking_Amount]           VARCHAR (45)   NOT NULL,
    [Booking_count]                  INT            NULL,
    [Percentage_share]               VARCHAR (42)   NOT NULL,
    [Vendor_Status]                  VARCHAR (10)   NOT NULL,
    [SortOrder]                      BIGINT         NULL
);

