CREATE TABLE [dbo].[Hotel_BookingGSTDetails] (
    [Id]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PKID]           INT           NOT NULL,
    [GstNumber]      VARCHAR (30)  NULL,
    [CompanyName]    VARCHAR (300) NULL,
    [EmailId]        VARCHAR (300) NULL,
    [MobileNo]       VARCHAR (15)  NULL,
    [Address]        VARCHAR (300) NULL,
    [City]           VARCHAR (100) NULL,
    [State]          VARCHAR (100) NULL,
    [PinCode]        VARCHAR (20)  NULL,
    [OrderId]        VARCHAR (200) NULL,
    [CompanyAddress] VARCHAR (500) NULL,
    [LegalName]      VARCHAR (200) NULL,
    CONSTRAINT [PK_Hotel_BookingGSTDetails] PRIMARY KEY CLUSTERED ([Id] ASC)
);

