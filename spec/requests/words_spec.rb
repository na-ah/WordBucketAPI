require 'rails_helper'

RSpec.describe WordsController, type: :controller do
  before do
    @word = Word.create!(word: 'test')
    @meaning = Meaning.create!(meaning: 'test_meaning', word_id: @word.id)
  end

  describe "GET #index" do
    it "returns a successfull response" do
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["words"].length).to eq(1)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new word" do
        expect { post :create, params: { word: 'new word' } }.to change(Word, :count).by(1)

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['word']).to eq('new word')
      end
    end

    context "with invalid parameters" do
      it "returns an error" do
        post :create, params: { word: '' }

        expect(response).to have_http_status(400)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "update the word" do
        patch :update, params: {id: @word.id, word: 'Updated'}

        expect(response).to have_http_status(200)
        expect(@word.reload.word).to eq('Updated')
      end

      it "update the word and adds a new meaning" do
        patch :update, params: { id: @word.id, word: 'Updated', meaning: 'new meaning' }

        expect(response).to have_http_status(200)
        expect(@word.reload.word).to eq('Updated')
        expect(@word.meanings.pluck(:meaning)).to include('new meaning')
      end

      it "update the word and adds a new example" do
        patch :update, params: { id: @word.id, word: 'Updated', example: 'new example'}

        expect(response).to have_http_status(200)
        expect(@word.reload.word).to eq('Updated')
        expect(@word.examples.pluck(:example)).to include('new example')
      end
    end

    context "with invalid parameters" do
      it "return an error" do
        patch :update, params: {id: @word.id, word: '' }

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["errors"]).not_to be_empty
      end
    end
  end

  describe "DELETE #destroy" do
    context "when the word exist" do
      it "deletes the word" do
        expect { delete :destroy, params: { id: @word.id }}.to change(Word, :count).by(-1)

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eq('Word deleted successfully')
      end
    end

    context "when the word does not exist" do
      it "returns an error" do
        delete :destroy, params: { id: -1 }

        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['error']).to eq('Word not found')
      end
    end
  end
end
