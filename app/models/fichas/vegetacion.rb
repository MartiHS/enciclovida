class Fichas::Vegetacion < Ficha

	self.table_name = "#{CONFIG.bases.fichasespecies}.vegetacion"
	self.primary_key = 'vegetacionId'

	has_many :relHabitatsVegetaciones , class_name: 'Fichas::Relhabitatvegetacion', foreign_key: 'vegetacionId'

end
