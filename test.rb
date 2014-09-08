  class Dog2
    def set_name(a_name)
      @name = a_name
    end
  end

  fido = Dog2.new
  fido.set_name("Fido")
  puts fido.instance_variables
eval "fido.@name"