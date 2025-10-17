CREATE TABLE [dbo].[Marine_City] (
    [ID]           BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [City_Name]    NVARCHAR (255) NULL,
    [airport_name] NVARCHAR (255) NULL,
    [airpoty_code] NVARCHAR (20)  NULL,
    CONSTRAINT [PK_Marine_City] PRIMARY KEY CLUSTERED ([ID] ASC)
);

