require 'rails_helper'

RSpec.describe ExamplesController, type: :controller do
  before do
    @word = Word.create!(word: 'test')
    @example = Example.create!(example: 'This is a test example', word_id: @word.id)
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["examples"].length).to eq(1)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new example" do
        expect { post :create, params: { example: 'New example', word_id: @word.id } }.to change(Example, :count).by(1)

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["data"]["example"]).to eq('New example')
      end
    end

    context "with invalid parameters" do
      it "returns an error" do
        post :create, params: { example: '', word_id: nil }

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).not_to be_empty
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the example" do
        patch :update, params: { id: @example.id, example: 'Updated example' }

        expect(response).to have_http_status(200)
        expect(@example.reload.example).to eq('Updated example')
      end
    end

    context "with invalid parameters" do
      it "returns an error" do
        patch :update, params: { id: @example.id, example: '' }

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).not_to be_empty
      end
    end
  end

  describe "DELETE #destroy" do
    context "when the example exist" do
      it "deletes the word" do
        expect {delete :destroy, params: { id: @example.id }}.to change(Example, :count).by(-1)

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eq('Example deleted successfully')
      end
    end

    context "when the example does not exist" do
      it "returns an error" do
        delete :destroy, params:  {id: -1}

        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['error']).to eq('Example not found')
      end
    end

  end
end
