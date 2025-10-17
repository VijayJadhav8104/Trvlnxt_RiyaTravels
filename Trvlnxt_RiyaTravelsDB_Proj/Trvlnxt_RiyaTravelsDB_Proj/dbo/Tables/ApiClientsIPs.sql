CREATE TABLE [dbo].[ApiClientsIPs] (
    [Id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientId]    INT           NULL,
    [IP]          VARCHAR (200) NULL,
    [CreatedBy]   INT           NULL,
    [CreatedDate] DATETIME      CONSTRAINT [DF_ApiClientsIPs_CreatedDate] DEFAULT (getdate()) NULL,
    [Status]      BIT           NULL,
    CONSTRAINT [PK_ApiClientsIPs] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-ClientID_IP]
    ON [dbo].[ApiClientsIPs]([ClientId] ASC, [IP] ASC);

