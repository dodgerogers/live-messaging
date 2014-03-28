class MessagesController < ApplicationController
  include ActionController::Live
  
  def index
    @messages = Message.all
  end
  
  def create
    response.headers["Content-Type"] = "text/javascript"
    @message = current_user.messages.build(message_params)
    @message.save
    $redis.publish('messages.create', [@message, @message.user].to_json)
    logger.debug([@message, @message.user].to_json)
  end
  
  def destroy
    response.headers["Content-Type"] = "text/javascript"
    @message = Message.find(params[:id]).destroy
    $redis.publish('messages.destroy', @message.to_json)
  end
  
  def events
    response.headers["Content-Type"] = "text/event-stream" 
    redis = Redis.new
    redis.subscribe("messages.create") do |on|
      on.message do |event, data|
        response.stream.write("data: #{data}\n\n")
      end
    end
  rescue IOError
    logger.info "Stream closed"
  ensure
    redis.quit
    response.stream.close
  end
  
  private
  
  def message_params
    params.require(:message).permit(:text)
  end
end