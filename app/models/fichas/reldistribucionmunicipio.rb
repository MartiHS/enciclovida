class Fichas::Reldistribucionmunicipio < Ficha

	self.table_name = "#{CONFIG.bases.fichasespecies}.reldistribucionmunicipio"
	self.primary_keys = :distribucionId,  :municipioId

	belongs_to :distribucion, :class_name => 'Fichas::Distribucion', :foreign_key => 'distribucionId'
	belongs_to :municipio, :class_name => 'Fichas::Municipio_F', :foreign_key => 'municipioId'

end
