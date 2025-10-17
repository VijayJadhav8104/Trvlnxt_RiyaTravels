CREATE TABLE [dbo].[HealthInsuranceClickLog] (
    [id]          INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [IpAddress]   VARCHAR (50)   NULL,
    [Location]    VARCHAR (50)   NULL,
    [CreatedDate] DATETIME       NULL,
    [CreatedBy]   NVARCHAR (50)  NULL,
    [BannerName]  NVARCHAR (100) NULL,
    [InquiryType] NVARCHAR (100) NULL,
    CONSTRAINT [PK_HealthInsuranceClickLog] PRIMARY KEY CLUSTERED ([id] ASC)
);

