class ExternalStakeholdersController < ApplicationController
  before_action :set_external_stakeholder, only: %i[ show edit update destroy ]
  before_action :has_user_rights?, only: %i[ index  ]
  before_action :has_current_user_rights?, only: %i[ show new edit update destroy]

  # GET /external_stakeholders or /external_stakeholders.json
  def index
    @organization = Organization.find_by(id: session[:organization_managed_id])
    # puts "*" * 50
    # puts session[:organization_managed_id]
    # puts "*" * 50
    @all_external_stakeholders = ExternalStakeholder.where(organization_id: session[:organization_managed_id])
    @stakeholder_requests = @organization.stakeholder_requests.where(validation: 0)
    @external_stakeholders_category = StakeholderCategory.all.sort {|a, b| a.name <=> b.name}
    @external_stakeholder = ExternalStakeholder.new()
  end

  # GET /external_stakeholders/1 or /external_stakeholders/1.json
  def show
    
  end

  # GET /external_stakeholders/new
  def new
    @external_stakeholder = ExternalStakeholder.new
  end

  # GET /external_stakeholders/1/edit
  def edit
  end

  # POST /external_stakeholders or /external_stakeholders.json
  def create
   
    @external_stakeholder = ExternalStakeholder.new(external_stakeholder_params)
    redirect_back fallback_location: root_path unless @external_stakeholder.organization.managers.include?(current_user)
    respond_to do |format|
      if @external_stakeholder.save
        format.html { redirect_to external_stakeholders_path, success: "External stakeholder was successfully created." }
        format.json { render :show, status: :created, location: @external_stakeholder }
      else
        format.html {render :new, status: :unprocessable_entity }
        format.json { render json: @external_stakeholder.errors, status: :unprocessable_entity }
      end
      puts @external_stakeholder.errors
    end
  end

  # PATCH/PUT /external_stakeholders/1 or /external_stakeholders/1.json
  def update
    respond_to do |format|
      if @external_stakeholder.update(external_stakeholder_params)
        format.html { redirect_to external_stakeholders_path, success: "External stakeholder was successfully updated." }
        format.json { render :show, status: :ok, location: @external_stakeholder }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @external_stakeholder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /external_stakeholders/1 or /external_stakeholders/1.json
  def destroy
    @external_stakeholder.destroy
    respond_to do |format|
      format.html { redirect_to external_stakeholders_url, success: "External stakeholder was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_external_stakeholder
      @external_stakeholder = ExternalStakeholder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def external_stakeholder_params
      params.require(:external_stakeholder).permit(:organization_id, :name, :email, :stakeholder_category_id)
    end

    def has_current_user_rights?
      redirect_back fallback_location: root_path unless ExternalStakeholder.find_by(id: params[:id]).organization.managers.include?(current_user)
    end
end
