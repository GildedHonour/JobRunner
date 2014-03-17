class NotesController < ApplicationController
  respond_to :html, :js

  def new
    @note = Note.new
    @note.notable = params[:notable_type].constantize.find(params[:notable_id])
  end

  def create
    note = Note.new(note_params)
    note.user = current_user
    note.save!

    redirect_to note.notable
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    note = Note.find(params[:id])
    note.attributes = note_params
    note.user = current_user
    note.save!

    redirect_to note.notable
  end

  private
  def note_params
    params.require(:note).permit(:notable_id, :notable_type, :note)
  end
end