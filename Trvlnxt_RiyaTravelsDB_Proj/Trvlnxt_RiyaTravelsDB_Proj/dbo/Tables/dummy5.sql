CREATE TABLE [dbo].[dummy5] (
    [Document No_]   NVARCHAR (255) NULL,
    [Air Line No_]   FLOAT (53)     NULL,
    [From City]      NVARCHAR (255) NULL,
    [To City]        NVARCHAR (255) NULL,
    [Departure Date] NVARCHAR (255) NULL,
    [Departure Time] DATETIME       NULL,
    [Arrival Date]   NVARCHAR (255) NULL,
    [Arrival Time]   DATETIME       NULL,
    [Document Type]  INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL
);

