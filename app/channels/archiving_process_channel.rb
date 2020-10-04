class ArchivingProcessChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'archiving_process'
  end
end
