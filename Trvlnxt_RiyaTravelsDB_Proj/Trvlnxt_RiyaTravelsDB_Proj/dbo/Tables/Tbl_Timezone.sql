CREATE TABLE [dbo].[Tbl_Timezone] (
    [Id]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Timezone]     NVARCHAR (100) NULL,
    [Locations]    NVARCHAR (MAX) NULL,
    [UTCPlusMinus] FLOAT (53)     NULL,
    CONSTRAINT [PK__Tbl_Time__3214EC0724645D95] PRIMARY KEY CLUSTERED ([Id] ASC)
);

