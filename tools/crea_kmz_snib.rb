require 'rubygems'
require 'trollop'

OPTS = Trollop::options do
  banner <<-EOS
Guarda en la base el kml y crea el kmz para una facil consulta y generacion del mismo

*** Este script se corre cada semana para generar los kml y los kmz

Usage:

rails r tools/crea_kmz_snib.rb -d

where [options] are:
  EOS
  opt :debug, 'Print debug statements', :type => :boolean, :short => '-d'
end

def kmz
  Proveedor.where('snib_id IS NOT NULL').find_each do |proveedor|
    #Especie.limit(400).each do |taxon|
    taxon = proveedor.especie
    #next unless taxon.id > 6040301
    puts "#{taxon.id}-#{taxon.nombre_cientifico}" if OPTS[:debug]
    # Quitamos estos taxones ya que estan muy pesados
    muchos_registros = [6040302, 6040409, 6053190, 6057583, 8000596]
    next if muchos_registros.include?(taxon.id)
    next unless taxon.species_or_lower?
    proveedor.kml

    if proveedor.snib_kml.present? && proveedor.snib_kml_changed?
      puts "\tCon KML" if OPTS[:debug]
      if proveedor.save
        if proveedor.kmz
          puts "\t\tCon KMZ" if OPTS[:debug]
        end
      end
    end
  end
end


start_time = Time.now

kmz

puts "Termino en #{Time.now - start_time} seg" if OPTS[:debug]