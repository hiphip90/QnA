class Condition
  def self.build_from_params(params)
    case params[:conditions]
    when 'Everywhere'
      params[:q]
    else
      { conditions: { params[:conditions].to_sym => params[:q] } }
    end
  end
end