CREATE TABLE [dbo].[PromoMaster] (
    [Pk_Id]          BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [amount]         DECIMAL (10, 2) NULL,
    [salesFrm_date]  DATE            NULL,
    [salesTo_date]   DATE            NULL,
    [travelFrm_date] DATE            NULL,
    [travelTo_date]  DATE            NULL,
    [Remark]         VARCHAR (500)   NULL,
    [insertDate]     DATE            NULL,
    [userID]         BIGINT          NULL,
    [modifiedDate]   DATE            NULL,
    [ModifiedBy]     INT             NULL,
    [status]         VARCHAR (5)     CONSTRAINT [DF_DisMaster_status] DEFAULT ('A') NULL,
    [promoCode]      VARCHAR (20)    NULL,
    CONSTRAINT [PK_promoMaster] PRIMARY KEY CLUSTERED ([Pk_Id] ASC)
);

