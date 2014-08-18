CREATE TABLE [dbo].[ProductGroupProperty](
	[ProductGroupPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[ProductGroupID] [int] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[InitialValue] [nvarchar](500) NULL,
	[TabOrder] [int] NULL,
	[IsMandatory] [bit] NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_ProductGroupProperty] PRIMARY KEY CLUSTERED 
(
	[ProductGroupPropertyID] ASC
)
)




GO
ALTER TABLE [dbo].[ProductGroupProperty] ADD  CONSTRAINT [DF_ProductGroupProperty_IsMandatory]  DEFAULT ((1)) FOR [IsMandatory]
GO
ALTER TABLE [dbo].[ProductGroupProperty]  WITH CHECK ADD  CONSTRAINT [FK_ProductGroupProperty_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO

ALTER TABLE [dbo].[ProductGroupProperty] CHECK CONSTRAINT [FK_ProductGroupProperty_Property]
GO
ALTER TABLE [dbo].[ProductGroupProperty]  WITH CHECK ADD  CONSTRAINT [FK_ProductGroupProperty_ProductGroup] FOREIGN KEY([ProductGroupID])
REFERENCES [dbo].[ProductGroup] ([ProductGroupID])
GO

ALTER TABLE [dbo].[ProductGroupProperty] CHECK CONSTRAINT [FK_ProductGroupProperty_ProductGroup]