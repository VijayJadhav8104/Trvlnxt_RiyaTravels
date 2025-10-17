CREATE TABLE [dbo].[tblSkipAirlineMaster] (
    [Id]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirlineCode] VARCHAR (10) NOT NULL,
    [ServiceFlag] VARCHAR (50) NOT NULL,
    [IsActive]    BIT          CONSTRAINT [DF_tblSkipAirlineMaster_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblSkipAirlineMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

