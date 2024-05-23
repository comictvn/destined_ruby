class Test2sController < ApplicationController
  before_action :set_test2, only: %i[ show edit update destroy ]

  # GET /test2s or /test2s.json
  def index
    @test2s = Test2.all
  end

  # GET /test2s/1 or /test2s/1.json
  def show
  end

  # GET /test2s/new
  def new
    @test2 = Test2.new
  end

  # GET /test2s/1/edit
  def edit
  end

  # POST /test2s or /test2s.json
  def create
    @test2 = Test2.new(test2_params)

    respond_to do |format|
      if @test2.save
        format.html { redirect_to test2_url(@test2), notice: "Test2 was successfully created." }
        format.json { render :show, status: :created, location: @test2 }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @test2.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test2s/1 or /test2s/1.json
  def update
    respond_to do |format|
      if @test2.update(test2_params)
        format.html { redirect_to test2_url(@test2), notice: "Test2 was successfully updated." }
        format.json { render :show, status: :ok, location: @test2 }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @test2.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test2s/1 or /test2s/1.json
  def destroy
    @test2.destroy

    respond_to do |format|
      format.html { redirect_to test2s_url, notice: "Test2 was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test2
      @test2 = Test2.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def test2_params
      params.fetch(:test2, {})
    end
end
