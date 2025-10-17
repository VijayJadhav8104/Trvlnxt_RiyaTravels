CREATE TABLE [dbo].[ApiLanding] (
    [Sno]              INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ServerUrl]        VARCHAR (200) NULL,
    [ServerHitCounter] BIGINT        NULL,
    CONSTRAINT [PK__ApiLandi__CA1FE4641872455D] PRIMARY KEY CLUSTERED ([Sno] ASC)
);

