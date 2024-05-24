class Test3sController < ApplicationController
  before_action :set_test3, only: %i[ show edit update destroy ]

  # GET /test3s or /test3s.json
  def index
    @test3s = Test3.all
  end

  # GET /test3s/1 or /test3s/1.json
  def show
  end

  # GET /test3s/new
  def new
    @test3 = Test3.new
  end

  # GET /test3s/1/edit
  def edit
  end

  # POST /test3s or /test3s.json
  def create
    @test3 = Test3.new(test3_params)

    respond_to do |format|
      if @test3.save
        format.html { redirect_to test3_url(@test3), notice: "Test3 was successfully created." }
        format.json { render :show, status: :created, location: @test3 }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @test3.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test3s/1 or /test3s/1.json
  def update
    respond_to do |format|
      if @test3.update(test3_params)
        format.html { redirect_to test3_url(@test3), notice: "Test3 was successfully updated." }
        format.json { render :show, status: :ok, location: @test3 }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @test3.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test3s/1 or /test3s/1.json
  def destroy
    @test3.destroy

    respond_to do |format|
      format.html { redirect_to test3s_url, notice: "Test3 was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test3
      @test3 = Test3.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def test3_params
      params.fetch(:test3, {})
    end
end
