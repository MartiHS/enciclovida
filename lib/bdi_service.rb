class BDIService

  def dameFotos(opts)
    bdi = CONFIG.bdi_imagenes
    fotos = []

    url = "#{bdi}/fotoweb/archives/5000-Banco de Imágenes/?#{opts[:campo]}='#{opts[:nombre]}'"
    url << "&p=#{opts[:pagina]-1}" if opts[:pagina]
    url_escape = URI.escape(url)
    uri = URI.parse(url_escape)

    req = Net::HTTP::Get.new(uri.to_s)
    req['Accept'] = 'application/vnd.fotoware.assetlist+json'

    begin
      res = Net::HTTP.start(uri.host, uri.port) {|http| http.request(req) }
      jres = JSON.parse(res.body)
      jres['data'].any?
    rescue => e
      jres = {'data' => []}
      {:estatus => 'error', :msg => e}
    end

    jres['data'].each do |x|
      foto = Photo.new
      foto.large_url = bdi+x['previews'][3]['href']
      foto.medium_url = bdi+x['previews'][7]['href']
      foto.native_page_url = bdi+x['href']
      foto.license = x['metadata']['340'].present? ? x['metadata']['340']['value'] : 'Sin licencia'
      foto.square_url = bdi+x['previews'][10]['href']
      foto.native_realname = x['metadata']['80'].present? ? x['metadata']['80']['value'].first : "Anónimo"
      fotos << foto
    end

    if jres['paging'].present? && jres['paging']['next'].present?
      ultima = jres['paging']['last'].split('&p=').last.to_i + 1
      {:estatus => 'OK', :ultima => ultima, :fotos => fotos}
    else
      {:estatus => 'OK', :ultima => nil, :fotos => fotos}
    end
  end
end

