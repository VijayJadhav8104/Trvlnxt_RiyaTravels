CREATE TABLE [Rail].[Agent_ServiceFee_MapperNew] (
    [Id]                     INT            IDENTITY (1, 1) NOT NULL,
    [FK_ServiceFeeId]        INT            NULL,
    [Fk_ProductListMasterId] INT            NULL,
    [ServiceFees]            DECIMAL (8, 2) NULL,
    [ServiceFeesParcent]     DECIMAL (8, 2) NULL,
    [Gst_on_Service_Fees]    DECIMAL (8, 2) NULL,
    [CreatedDate]            DATETIME       NULL,
    [ModifiedDate]           DATETIME       NULL,
    [CreatedBy]              VARCHAR (50)   NULL,
    [ModifyBy]               VARCHAR (50)   NULL
);

