CREATE TABLE [dbo].[HotelApiClientsIPs] (
    [Id]              INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientCompanyId] INT           NULL,
    [IP]              VARCHAR (200) NULL,
    [CreatedBy]       INT           NULL,
    [CreatedDate]     DATETIME      CONSTRAINT [DF_HotelApiClientsIPs_CreatedDate] DEFAULT (getdate()) NULL,
    [Status]          BIT           NULL,
    CONSTRAINT [PK_HotelApiClientsIPs] PRIMARY KEY CLUSTERED ([Id] ASC)
);

