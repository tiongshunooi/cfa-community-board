class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.where(["location = ?", "current_user.location"])
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @issue = Issue.find(params[:id])
    @comment = Comment.new
    @comments = Comment.where(["issue_id=?",@issue.id])
    @comments = @comments.sort_by {|c| Time.now - c.updated_at}
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)
    @issue.user_id = current_user.id
    @issue.postcode = current_user.postcode
    @issue.receipt = generate_random
    @issue.location = current_user.location
    @issue.classification = "issue"

    respond_to do |format|
      if @issue.save
        format.html { redirect_to root_path, notice: "Issue was successfully created." }
        format.json { render :show, status: :created, location: @issue }
      else
        format.html { render :new }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Issue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.require(:issue).permit(:user_id, :title, :content, :receipt, :image)
    end

    def generate_random
      @receipt = []
      4.times do |x|
        x = 1 + rand(9)
        @receipt << x.to_s
      end
      if Issue.where("receipt = ?", @receipt.join).first
        generate_random
      else
        return @receipt.join
      end
    end
end
