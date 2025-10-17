CREATE TABLE [dbo].[MTTicketNumberEnable] (
    [ID]         INT          IDENTITY (1, 1) NOT NULL,
    [VendorName] VARCHAR (50) NULL,
    [IsActive]   BIT          NULL,
    CONSTRAINT [PK_MTTicketNumberEnable] PRIMARY KEY CLUSTERED ([ID] ASC)
);

