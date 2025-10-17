CREATE TABLE [dbo].[RetriveHotelReconSchedularInfo] (
    [Id]           INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MethodName]   VARCHAR (50) NULL,
    [Status]       VARCHAR (50) NULL,
    [InsertedDate] DATETIME     NULL,
    CONSTRAINT [PK_RetriveHotelReconSchedularInfo] PRIMARY KEY CLUSTERED ([Id] ASC)
);

