class NotesController < ApplicationController

  # TODO: explore application to see if authorization is needed here.

  def create
    note = Note.new(note_params)

    if craftsman.present?
      note.update_attribute(:craftsman_id, craftsman.id)
    end

    # TODO: I don't think we should be specifying the types of access levels we have. We should change this
    redirect_to applicant_path(note.applicant), :notice => ("Only craftsmen can leave notes." if craftsman.nil?)
  end

  def edit
    @note = Note.find(params[:id])
    render :partial => 'applicants/note_edit_form'
  end

  def update
    note = Note.find(params[:id])

    if craftsman.present?
      note.update_attributes(note_params)
    end
    # TODO: Same here
    redirect_to applicant_path(note.applicant), :notice => ("Only craftsmen can edit notes." if craftsman.nil?)
  end

  private

  def craftsman
    current_user.craftsman
  end

  def note_params
    params.require(:note).permit(:body, :applicant_id)
  end
end
