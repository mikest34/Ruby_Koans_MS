class Proxy
	attr_accessor :messages

	def initialize(target_object)
		@object = target_object
		self.messages = []
		self
	end

	def method_missing(method_name, *args)
		self.messages << method_name
		@object.send(method_name, *args)
	end

	def respond_to? (method_name)
		@object.send(:respond_to, method_name)
	end

	def called? (method_name)
		self.messages.include?(method_name)
	end

	def number_of_times_called (method_name)
		method_call_cnt = 0
		if self.messages.include?(method_name)
			self.messages.each do |item|
				method_call_cnt += 1 if item == method_name
			end
		end
		method_call_cnt
	end

end 

class Television
  attr_accessor :channel

  def power
    if @power == :on
      @power = :off
    else
      @power = :on
    end
  end

  def on?
    @power == :on
  end
end

tv = Proxy.new(Television.new)
tv.power
tv.channel = 48
tv.power
puts tv.number_of_times_called(:channel=)
puts tv.number_of_times_called?(:power)


