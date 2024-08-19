require 'rails_helper'

RSpec.describe Words::ExamplesController, type: :controller do
  before do
    @word = Word.create!(word: 'test')
    @example = Example.create!(example: 'test_example', word_id: @word.id)
  end

  describe "GET #index" do
    it "turns a successful response" do
      get :index, params: { word_id: @word.id }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["examples"].length).to eq(1)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new example" do
        expect { post :create, params: { example: 'new example', word_id: @word.id }}.to change(Example, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "returns an error" do
        post :create, params: { example: '', word_id: @word.id }

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).not_to be_empty
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the word" do
        patch :update, params: { word_id: @word.id, id: @example.id, example: "Updated Example" }

        expect(response).to have_http_status(200)
        expect(@example.reload.example).to eq('Updated Example')
      end
    end

    context "with invalid parameters" do
      it "returns an error" do
        patch :update, params: { word_id: @word.id, id: @example.id, example: '' }

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).not_to be_empty
      end
    end
  end

  describe "DELETE #destroy" do
    context "when the example exist" do
      it "deletes the word" do
        expect {delete :destroy, params: { word_id: @word.id, id: @example.id } }.to change(Example, :count).by(-1)

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eq('Example deleted successfully')
      end
    end

    context "when the example does not exist" do
      it "returns an error" do
        delete :destroy, params: {word_id: @word.id, id: -1}

        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['error']).to eq("Example not found")
      end
    end
  end

end
