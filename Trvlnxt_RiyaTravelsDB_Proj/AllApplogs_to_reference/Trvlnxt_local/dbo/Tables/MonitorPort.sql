CREATE TABLE [dbo].[MonitorPort] (
    [Id]      INT           IDENTITY (1, 1) NOT NULL,
    [Message] VARCHAR (MAX) NULL,
    [Dtime]   DATETIME      NULL,
    CONSTRAINT [PK_MonitorPort] PRIMARY KEY CLUSTERED ([Id] ASC)
);

