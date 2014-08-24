CREATE TABLE [dbo].[ProductProperty](
	[ProductPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductGroupPropertyID] [int] NOT NULL,
	[Value] [nvarchar](1000) NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_ProductProperty] PRIMARY KEY CLUSTERED 
(
	[ProductPropertyID] ASC
)
)




GO
ALTER TABLE [dbo].[ProductProperty]  WITH CHECK ADD  CONSTRAINT [FK_ProductProperty_ProductGroupProperty] FOREIGN KEY([ProductGroupPropertyID])
REFERENCES [dbo].[ProductGroupProperty] ([ProductGroupPropertyID])
GO

ALTER TABLE [dbo].[ProductProperty] CHECK CONSTRAINT [FK_ProductProperty_ProductGroupProperty]
GO
ALTER TABLE [dbo].[ProductProperty]  WITH CHECK ADD  CONSTRAINT [FK_ProductProperty_Product1] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO

ALTER TABLE [dbo].[ProductProperty] CHECK CONSTRAINT [FK_ProductProperty_Product1]