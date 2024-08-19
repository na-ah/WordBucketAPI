require 'rails_helper'

RSpec.describe Words::MeaningsController, type: :controller do
  before do
    @word = Word.create!(word: 'test')
    @meaning = Meaning.create!(meaning: 'test_meaning', word_id: @word.id)
  end

  describe "GET #index" do
    it "turns a successful response" do
      get :index, params: { word_id: @word.id }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["meanings"].length).to eq(1)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new meaning" do
        expect { post :create, params: { meaning: 'new meaning', word_id: @word.id }}.to change(Meaning, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "returns an error" do
        post :create, params: { meaning: '', word_id: @word.id }

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).not_to be_empty
      end
    end
  end

  describe "DELETE #destroy" do
    context "when the meaning exist" do
      it "deletes the word" do
        expect {delete :destroy, params: { word_id: @word.id, id: @meaning.id } }.to change(Meaning, :count).by(-1)

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eq('Meaning deleted successfully')
      end
    end

    context "when the meaning does not exist" do
      it "returns an error" do
        delete :destroy, params: {word_id: @word.id, id: -1}

        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['error']).to eq("Meaning not found")
      end
    end
  end
end
