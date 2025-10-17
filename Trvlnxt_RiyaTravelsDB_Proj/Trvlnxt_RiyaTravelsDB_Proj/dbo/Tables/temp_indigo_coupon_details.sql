CREATE TABLE [dbo].[temp_indigo_coupon_details] (
    [id]              INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [pnr]             VARCHAR (100) NULL,
    [officeid]        VARCHAR (100) NULL,
    [coupon_status]   VARCHAR (100) NULL,
    [segmentName]     VARCHAR (100) NULL,
    [passanger_name]  VARCHAR (MAX) NULL,
    [createdDateTime] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

