require 'rails_helper'

RSpec.describe Words::HistoriesController, type: :controller do
  before do
    @word = Word.create!(word: 'test')
    @history = History.create!(duration: '3.21', datetime: '2024-08-19T12:50:56Z', result: true, word_id: @word.id)
  end

  describe "GET #index" do
    it "turns a successful response" do
      get :index, params: { word_id: @word.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["histories"].length).to eq(1)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new history" do
        expect { post :create,
          params: {
            duration: 1.23,
            result: false,
            datetime: '2024-08-19T14:30:10Z',
            word_id: @word.id,
          }
        }.to change(History, :count).by(1)
      end
    end

    context "with unvalid parameters" do
      it "returns an error" do
        post :create, params: {
          word_id: @word.id,
          history: {
            duration: nil,
            result: nil,
            datetime: nil
          }
        }

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).not_to be_empty
      end
    end
  end

  describe "GET #show" do
    it "returns the specified history" do
      get :show, params: { word_id: @word.id, id: @history.id }

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)["history"]

      expect(json_response["id"]).to eq(@history.id)
      expect(json_response["duration"]).to eq(@history.duration)
      expect(json_response["result"]).to eq(@history.result)
      expect(json_response["datetime"]).to eq(@history.datetime.as_json)
    end
  end

  describe "DELETE #destroy" do
    context "when the history exist" do
      it "deletes the history" do
        expect { delete :destroy, params: { word_id: @word.id, id: @history.id } }.to change(History, :count).by(-1)

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eq('History deleted successfully')
      end
    end

    context "when the history does not exist" do
      it "returns an error" do
        delete :destroy, params: { word_id: @word.id, id: -1 }

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).to eq('History not found')
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "update the history" do
        patch :update,
        params: {
          word_id: @word.id,
          id: @history.id,
          duration: 3.33,
          result: false,
          datetime: '2024-08-19T18:00:00Z'
        }

        expect(response).to have_http_status(200)
        updated_history = History.find(@history.id)
        expect(updated_history["duration"]).to eq(3.33)
        expect(updated_history["result"]).to eq(false)
        expect(updated_history["datetime"]).to eq('2024-08-19T18:00:00Z')

      end
    end
  end
end
