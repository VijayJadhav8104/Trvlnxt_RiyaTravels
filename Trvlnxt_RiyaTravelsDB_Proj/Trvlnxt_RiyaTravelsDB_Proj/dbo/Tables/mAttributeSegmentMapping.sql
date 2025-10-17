CREATE TABLE [dbo].[mAttributeSegmentMapping] (
    [ID]                 INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AttributeMappingId] INT           NULL,
    [SegmentName]        VARCHAR (50)  NULL,
    [Type]               VARCHAR (50)  NULL,
    [FreeText]           VARCHAR (MAX) NULL,
    [IsActive]           BIT           CONSTRAINT [DF_mAttributeSegmentMapping_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_mAttributeSegmentMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);

