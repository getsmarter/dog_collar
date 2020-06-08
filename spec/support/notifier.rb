# frozen_string_literal: true

class Notifier
  def initialize
    @semaphore = Mutex.new
    @condition = ConditionVariable.new
  end

  def wait_for_notification
    semaphore.synchronize { condition.wait(semaphore) }
  end

  def notify
    semaphore.synchronize { condition.signal }
  end

  private

  attr_accessor :condition, :semaphore
end
