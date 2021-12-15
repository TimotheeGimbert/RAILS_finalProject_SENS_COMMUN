class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[ show edit update destroy ]
  before_action :has_user_rights?, only: %i[ index show ]
  before_action :has_legal_rep_rights?, only: %i[ edit update ]
  before_action :has_admin_rights?, only: %i[ new create destroy ]

  # GET /organizations or /organizations.json
  def index
    @organizations = Organization.all
    case params[:selected]
      when "organizations_participation"
        # Gets organizations where the current user is a stakeholder, then renders the appropriate partial
        @view_title = "Organisations dont je suis partie-prenante"
        @organizations = Organization.where(external_stakeholders: ExternalStakeholder.find_by(user: current_user))
    end

    @view_title = "Toutes les organisations"
    sidebar_organizations()
  end

  # GET /organizations/1 or /organizations/1.json
  def show
    if params[:show] && params[:show] == "StakeholderRequest"
      @stakeholder_request = StakeholderRequest.new()
    end
    sidebar_organizations()
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations or /organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: "Organization was successfully created." }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1 or /organizations/1.json
  def update
    if (params[:logo])
      @organization.logo.attach(params[:logo])
    end
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to user_dashboards_organizations_legalreps_path(organization_managed: @organization.id) , notice: "Organization was successfully updated." }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1 or /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, notice: "Organization was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def create_logo
      @organization = Organization.find(params[:organization_id])
      @organization.logo.attach(params[:logo])
      redirect_to user_organizations_legalreps_path(organization_managed: @organization.id)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def organization_params
      params.require(:organization).permit(:name, :nickname, :creation_date, :address, :address_complement, :zip_code, :city_id, :email, :phone_number, :status_id, :siren, :description, :activity_sector_id, :naf_ape, :logo_url, :website_url, :logo)
    end
    def sidebar_organizations()
      if params[:search_by]
        
        @sidebar_links =[]
        case params[:search_by]
          when "geo_zones"
            @sidebar_title = "Zones géographiques"
            City.all.each { |city| @sidebar_links.push( {id:city.id, label:city.name} ) }
            if params[:categ_id]
              @organizations = Organization.all.reject{|organization| organization.city.id != params[:categ_id].to_i}
              @view_title = City.find_by(id: params[:categ_id]).name
            end
          when "sectors"
            @sidebar_title = "Secteurs d'activité"
            ActivitySector.all.each { |sector| @sidebar_links.push( {id:sector.id, label:sector.name} ) }
            if params[:categ_id]
              @organizations = Organization.all.reject{|organization| organization.activity_sector.id != params[:categ_id].to_i}
              @view_title = ActivitySector.find_by(id: params[:categ_id]).name
            end
          when "status"
            @sidebar_title = "Status"
            Status.all.each { |status| @sidebar_links.push( {id:status.id, label:status.name} ) }
            if params[:categ_id]
              @organizations = Organization.all.reject{|organization| organization.status.id != params[:categ_id].to_i}
              @view_title = Status.find_by(id: params[:categ_id]).name
            end
        end
      end
    end
end
