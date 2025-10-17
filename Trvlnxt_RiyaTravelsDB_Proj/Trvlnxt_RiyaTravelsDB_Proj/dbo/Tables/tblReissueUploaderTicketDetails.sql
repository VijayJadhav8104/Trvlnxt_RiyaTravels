CREATE TABLE [dbo].[tblReissueUploaderTicketDetails] (
    [ID]             BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [GDSPNR]         NVARCHAR (255)  NULL,
    [TicketNumber]   NVARCHAR (255)  NULL,
    [BasicFare]      DECIMAL (18, 2) NULL,
    [Tax]            DECIMAL (18, 2) NULL,
    [TotalFare]      DECIMAL (18, 2) NULL,
    [YQ]             DECIMAL (18, 2) NULL,
    [YrTax]          DECIMAL (18, 2) NULL,
    [InTax]          DECIMAL (18, 2) NULL,
    [JnTax]          DECIMAL (18, 2) NULL,
    [OCTax]          DECIMAL (18, 2) NULL,
    [ExtraTax]       DECIMAL (18, 2) NULL,
    [YMTax]          DECIMAL (18, 2) NULL,
    [WOTax]          DECIMAL (18, 2) NULL,
    [OBTax]          DECIMAL (18, 2) NULL,
    [RFTax]          DECIMAL (18, 2) NULL,
    [DiscriptionTax] NVARCHAR (MAX)  NULL,
    [Status]         NVARCHAR (255)  NULL,
    [InsertedDate]   DATETIME        NULL,
    CONSTRAINT [PK_tblReissueUploaderTicketDetails] PRIMARY KEY CLUSTERED ([ID] ASC)
);

