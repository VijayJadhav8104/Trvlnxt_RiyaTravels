CREATE TABLE [dbo].[tblbaggagedetails] (
    [ID]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FromSector]   VARCHAR (50)  NULL,
    [Tosector]     VARCHAR (50)  NULL,
    [Weight]       VARCHAR (50)  NULL,
    [Carrier]      VARCHAR (50)  NULL,
    [IsActive]     BIT           NULL,
    [FromCountry]  VARCHAR (10)  NULL,
    [ToCountry]    VARCHAR (10)  NULL,
    [ProductClass] VARCHAR (250) NULL,
    CONSTRAINT [PK_tblbaggagedetails] PRIMARY KEY CLUSTERED ([ID] ASC)
);

