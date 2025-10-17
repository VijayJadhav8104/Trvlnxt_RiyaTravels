CREATE TABLE [dbo].[BlogTemplateDetails] (
    [Id]               INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BlogId]           NVARCHAR (MAX) NULL,
    [PointHead]        NVARCHAR (MAX) NULL,
    [PointSubHead]     NVARCHAR (MAX) NULL,
    [PointDescription] NVARCHAR (MAX) NULL,
    [Point_Images]     NVARCHAR (MAX) NULL,
    [Point_img_link]   NVARCHAR (MAX) NULL,
    [PointImgUrl]      NVARCHAR (MAX) NULL,
    [OrderNumber]      NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_BlogTemplateDetails] PRIMARY KEY CLUSTERED ([Id] ASC)
);

