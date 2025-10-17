CREATE TABLE [Hotel].[VendorReportMailerCheck] (
    [Pkid]        INT      IDENTITY (1, 1) NOT NULL,
    [CurrentDate] DATETIME NULL,
    [MailSent]    BIT      NULL,
    PRIMARY KEY CLUSTERED ([Pkid] ASC)
);

